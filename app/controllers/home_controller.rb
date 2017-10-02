class HomeController < ApplicationController
  def index
    thing = JSON.parse RestClient.get('https://rsbuddy.com/exchange/summary.json').body
    @items = []
    thing.each do |item|
      next if item[1]['overall_average'] <= 0
      # @items << [item[0], item[1]['name'], item[1]['overall_average']]
      @items << item[1]
    end
    @items = @items.sample(5)
  end
end
