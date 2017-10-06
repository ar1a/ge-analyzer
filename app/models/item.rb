class Item < ApplicationRecord
  has_many :price_updates

  def price
    price_updates.last.overall_average
  end

  def buy_price
    price_updates.last.buy_average
  end

  def sell_price
    price_updates.last.sell_average
  end

  def margin
    sell_price - buy_price
  end

  def icon_link
    # if icon.nil?
    #   update(icon: JSON.parse(RestClient.get("http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item=#{runescape_id}").body)['item']['icon'])
    # end
    # icon
    "http://services.runescape.com/m=itemdb_oldschool/1507199882434_obj_sprite.gif?id=#{runescape_id}"
    # "https://rsbuddy.com/items/#{runescape_id}.png"
  end

  def price_history(day_range = 0)
    if day_range <= 0
      price_updates.pluck(:created_at, :overall_average)
    else
      updates = price_updates
                .where(
                  created_at: (DateTime.current - day_range.days)..DateTime.current
                )
                .pluck(:created_at, :overall_average)
      if day_range < 7
        updates
      elsif day_range == 7
        5.step(updates.size - 1, 6).map { |i| updates[i] } if day_range == 7
      elsif day_range >= 30
        # averages each day
        a = price_updates.group_by{ |x| x.created_at.to_date }
        tmp = []
        a.each do |b|
          b = b
          tmp << [b[0], b[1].map(&:overall_average).reduce(:+) / b[1].size.to_f]
        end
        tmp
      end
    end
  end

  def get_past_month(force = false)
    return if timed_out? && !force
    time = (DateTime.now - 30.days).strftime('%Q')
    data = JSON.parse RestClient.get("https://api.rsbuddy.com/grandExchange?a=graph&g=30&start=#{time}&i=#{runescape_id}").body
    update(last_update_time: DateTime.now)
    price_updates.destroy_all
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
    (Time.now - last_update_time) < 1.hour
  end

end
