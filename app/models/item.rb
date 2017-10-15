class Item < ApplicationRecord
  has_many :price_updates

  def price
    price_updates.last.overall_average
  rescue NoMethodError
    0
  end

  def buy_price
    price_updates.last.buy_average
  rescue NoMethodError
    0
  end

  def sell_price
    price_updates.last.sell_average
  rescue NoMethodError
    puts "rescued"
    0
  end

  def roi
    return 0.to_f if buy_price <= 0
    (sell_price.to_f - buy_price.to_f) / buy_price.to_f
  end

  def margin
    sell_price - buy_price
  end

  def margin_style
    margin > 0 ? 'positive' : 'negative'
  end

  def icon_link
    # if icon.nil?
    #   update(icon: JSON.parse(RestClient.get("http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item=#{runescape_id}").body)['item']['icon'])
    # end
    # icon
    # "http://services.runescape.com/m=itemdb_oldschool/1507199882434_obj_sprite.gif?id=#{runescape_id}"
    "http://cdn.rsbuddy.com/items/#{runescape_id}.png"
  end

  def price_history(day_range = 0)
    if day_range <= 0
      price_updates.pluck(:created_at, :overall_average)
    elsif day_range < 3
      Rails.cache.fetch("#{cache_key}/price_history/daily") do
        get_price_updates(day_range)
      end
    elsif day_range >= 3 && day_range < 7
      Rails.cache.fetch("#{cache_key}/price_history/three") do
        updates = get_price_updates(day_range)
        2.step(updates.size - 1, 3).map { |i| updates[i] }
      end
    elsif day_range == 7
      Rails.cache.fetch("#{cache_key}/price_history/week") do
        updates = get_price_updates(day_range)
        5.step(updates.size - 1, 6).map { |i| updates[i] }
      end
    elsif day_range >= 30
      Rails.cache.fetch("#{cache_key}/price_history/month") do
        a = price_updates.group_by { |x| x.created_at.to_date }
        tmp = []
        a.each do |b|
          b = b
          tmp << [b[0], (b[1].map(&:overall_average).reduce(:+) / b[1].size.to_f).to_i]
        end
        tmp
      end
    end
  end

  def get_price_updates(day_range)
    price_updates
      .where(
      created_at: (DateTime.current - day_range.days)..DateTime.current
    )
      .pluck(:created_at, :overall_average)
  end

  def get_past_month(force = false, recursion = 0)
    return if timed_out? && !force
    return if recursion > 15
    time = (DateTime.now - 30).strftime('%Q')
    data = JSON.parse RestClient.get("https://api.rsbuddy.com/grandExchange?a=graph&g=30&start=#{time}&i=#{runescape_id}").body
    # TODO: Somehow fix this bug?
    # If the first entry is new-ish, retry the get
    # The rsbuddy api only seems to return it for the past week or so sometimes

    delta = (DateTime.now - DateTime.strptime(data[1]['ts'].to_s, '%Q')) 
    if delta < 25
      puts delta.to_i
      puts "Get failed! retrying"
      sleep 3
      return get_past_month(force, recursion + 1)
    end
    price_updates.destroy_all
    update(last_update_time: DateTime.now)
    data.each do |entry|
      p = price_updates.build
      p.buy_average = entry['buyingPrice'].to_i
      p.sell_average = entry['sellingPrice'].to_i
      p.overall_average = entry['overallPrice'].to_i
      p.created_at = DateTime.strptime(entry['ts'].to_s, '%Q')
      p.save
    end
  end

  def timed_out?
    return false if last_update_time.nil?
    (Time.now - last_update_time) < 30.seconds
  end
end
