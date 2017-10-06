class PriceUpdate < ApplicationRecord
  belongs_to :item, touch: true
  def self.update_all
    thing = JSON.parse RestClient.get('https://rsbuddy.com/exchange/summary.json').body
    thing.each do |i|
      i = i[1]
      # next if i['overall_average'].to_i <= 0 && i['buy_average'].to_i <= 0 && i['sell_average'].to_i <= 0
      item = Item.find_or_create_by(runescape_id: i['id'])
      item.update(name: i['name'])
      update = item.price_updates.build
      update.buy_average = i['buy_average'].to_i
      update.sell_average = i['sell_average'].to_i
      update.overall_average = i['overall_average'].to_i
      update.save
    end
  end
end
