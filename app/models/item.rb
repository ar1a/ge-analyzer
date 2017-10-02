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

  def icon_link
    if icon.nil?
      update(icon: JSON.parse(RestClient.get("http://services.runescape.com/m=itemdb_oldschool/api/catalogue/detail.json?item=#{runescape_id}").body)['item']['icon'])
    end
    icon
  end

  def price_history
    price_updates.pluck(:created_at, :overall_average)
  end
end
