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
    clnt = HTTPClient.new
    Parallel.each(Item.all) do |i|
    # Item.all.each do |i|
      begin
        puts "Worker: #{Parallel.worker_number}"
        thing = JSON.parse clnt.get_content("https://api.rsbuddy.com/grandExchange?a=guidePrice&i=#{i.runescape_id}")
        update = i.price_updates.build
        update.buy_average = thing['overall'].to_i
        update.sell_average = thing['buying'].to_i
        update.overall_average = thing['selling'].to_i
        update.roi = if update.buy_average <= 0
                       0
                     else
                       (update.sell_average.to_f - update.buy_average.to_f) / update.overall_average.to_f
                     end
        i.update_ema
        i.update_roi(update.roi)
        i.update_margin
        i.update(buying_rate: thing['buyingQuantity'],
                 selling_rate: thing['sellingQuantity']) # TODO: remove me
        # time = (DateTime.now - 1).strftime('%Q')
        # thing = JSON.parse clnt.get_content("https://api.rsbuddy.com/grandExchange?a=graph&i=#{i.runescape_id}&start=#{time}&g=1440")
        # thing = thing[0] if thing.class == Array
        # next if thing.nil?
        # i.update(buying_rate: thing['buyingCompleted'].to_i,
        #          selling_rate: thing['sellingCompleted'].to_i)
      rescue => e
        logger.info "Error thrown processing #{i.name} in PriceUpdate#update_all, continuing"
        logger.debug e
        clnt = HTTPClient.new
        next
      end
    end
    PriceUpdate.connection.reconnect!
  end
end
