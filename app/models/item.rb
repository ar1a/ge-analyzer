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
  end

  def price_history(day_range = 0)
    if day_range <= 0
      price_updates.pluck(:created_at, :overall_average)
    else
      price_updates
        .where(
          created_at: (DateTime.current - day_range.days)..DateTime.current
        )
        .pluck(:created_at, :overall_average)
    end
  end
  # really should only be used in development
  def get_past_week
    data = JSON.parse RestClient.get("https://api.rsbuddy.com/grandExchange?a=graph&i=#{runescape_id}").body
    data.each do |entry|
      p = price_updates.build
      p.buy_average = entry['buyingPrice'].to_i
      p.sell_average = entry['sellingPrice'].to_i
      p.overall_average = entry['overallPrice'].to_i
      p.created_at = DateTime.strptime(entry['ts'].to_s, '%Q')
      p.save
    end
  end
end
