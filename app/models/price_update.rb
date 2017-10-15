class PriceUpdate < ApplicationRecord
  belongs_to :item, touch: true
  # def self.update_all
  #   thing = JSON.parse RestClient.get('https://rsbuddy.com/exchange/summary.json').body
  #   thing.each do |i|
  #     i = i[1]
  #     next if i['overall_average'].to_i <= 0
  #     item = Item.find_by(runescape_id: i['id'])
  #     update = item.price_updates.build
  #     update.buy_average = i['buy_average'].to_i
  #     update.sell_average = i['sell_average'].to_i
  #     update.overall_average = i['overall_average'].to_i
  #     update.roi = if update.buy_average <= 0
  #                    0
  #                  else
  #                    (update.sell_average.to_f - update.buy_average.to_f) / update.overall_average.to_f
  #                  end
  #     item.update(roi: update.roi)
  #     update.save
  #   end
  # end
  def self.update_all
    Parallel.each(Item.all) do |i|
      thing = JSON.parse RestClient.get("https://api.rsbuddy.com/grandExchange?a=guidePrice&i=#{i.runescape_id}")
      update = i.price_updates.build
      update.buy_average = thing['overall'].to_i
      update.sell_average = thing['buying'].to_i
      update.overall_average = thing['selling'].to_i
      update.roi = if update.buy_average <= 0
                     0
                   else
                     (update.sell_average.to_f - update.buy_average.to_f) / update.overall_average.to_f
                   end
      i.update(roi: update.roi, buying_rate: thing['buyingQuantity'], selling_rate: thing['sellingQuantity'])
    end
    PriceUpdate.connection.reconnect!
  end
end
