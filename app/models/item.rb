class Item < ApplicationRecord
  has_many :price_updates

  scope :positive_roi, lambda {
    where('roi > 0.001')
      .where('selling_rate > 30')
      .where('buying_rate > 30')
  }

  def roi
    if (val = self[:roi]).nil? || val.nan?
      0
    else
      val
    end
  end

  def recommended_buy_price
    if (val = self[:recommended_buy_price]).nil? || val.nan?
      0
    else
      val
    end
  end

  def recommended_sell_price
    if (val = self[:recommended_sell_price]).nil? || val.nan?
      0
    else
      val
    end
  end

  def most_recent
    price_updates.order('created_at desc').last
  end

  def buying_rate
    if (val = self[:buying_rate]).nil?
      0
    else
      val
    end
  end

  def selling_rate
    if (val = self[:buying_rate]).nil?
      0
    else
      val
    end
  end

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
    puts 'rescued'
    0
  end

  def margin
    recommended_sell_price - recommended_buy_price
  end

  def icon_link
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

  def update_roi(other)
    roi = margin / recommended_buy_price
    update(roi: roi)
  rescue
    update(roi: other)
  end

  def update_ema
    buy = price_updates
          .where(created_at: 1.day.ago..DateTime.now)
          .order('created_at asc')
          .pluck(:buy_average)
          .reject { |x| x <= 0 }
    buy.extend Basic::Stats
    buy.reject_outliers!
    update(recommended_buy_price: buy.ema)
    sell = price_updates
           .where(created_at: 1.day.ago..DateTime.now)
           .order('created_at asc')
           .pluck(:sell_average)
           .reject { |x| x <= 0 }
    sell.extend Basic::Stats
    sell.reject_outliers!
    update(recommended_sell_price: sell.ema)
  rescue
    update(recommended_buy_price: most_recent.buy_average,
           recommended_sell_price: most_recent.sell_average)
  end

  def get_past_month(force = false, recursion = 0)
    return if timed_out? && !force
    return if recursion > 15
    time = (DateTime.now - 30).strftime('%Q')
    data = JSON.parse RestClient.get("https://api.rsbuddy.com/grandExchange?a=graph&g=30&start=#{time}&i=#{runescape_id}").body
    # TODO: Somehow fix this bug?
    # If the first entry is new-ish, retry the get
    # The rsbuddy api only seems to return it for the past week or so sometimes

    delta = p(DateTime.now - DateTime.strptime(data[1]['ts'].to_s, '%Q'))
    if delta < 25
      puts delta.to_i
      puts 'Get failed! retrying'
      sleep 3
      return get_past_month(force, recursion + 1)
    end
    price_updates.destroy_all
    update(last_update_time: DateTime.now)
    data.each do |entry|
      p = price_updates.build
      p.buy_average = entry['sellingPrice'].to_i
      p.sell_average = entry['buyingPrice'].to_i
      p.overall_average = entry['overallPrice'].to_i
      p.created_at = DateTime.strptime(entry['ts'].to_s, '%Q')
      p.roi = if p.buy_average <= 0
                0
              else
                (p.sell_average.to_f - p.buy_average.to_f) / p.overall_average.to_f
              end
      p.save
    end
    update_ema
    update_roi(price_updates.last.roi)
  end

  def timed_out?
    return false if last_update_time.nil?
    (Time.now - last_update_time) < 30.seconds
  end

  def self.update_all
    thing = JSON.parse RestClient.get('https://rsbuddy.com/exchange/summary.json').body
    thing.each do |i|
      i = i[1]
      item = Item.find_or_create_by(runescape_id: i['id'])
      item.update(name: i['name'])
    end
  end
end
