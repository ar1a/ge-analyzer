class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = if params[:q].nil?
               # Item.all.sample(5)
               arr = []
               items = Item.all
               loop do
                 break if arr.count >= 5
                 i = items.sample
                 # TODO: make these options?
                 arr << i if i.margin > 0 && i.roi > 1 && i.roi < 150
               end
               arr
             else
               @search = true
               @q.result
             end
    @items = ItemDecorator.decorate_collection(@items)
  end
end
