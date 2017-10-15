class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = if params[:q].nil?
               # Item.all.sample(5)
               arr = []
               # items = Item.all
               items = Item.positive_roi
               repeat = 0
               loop do
                 break if arr.count >= 5
                 break if repeat > 50
                 repeat += 1
                 i = items.sample
                 next if i.nil?
                 # TODO: make these options?
                 arr << i if i.margin > 0
               end
               arr
             else
               @search = true
               @q.result
             end
    @items = @items.first(50) # limit it
    @items.sort! { |x, y| y.roi <=> x.roi }
    @items = ItemDecorator.decorate_collection(@items)
  end
end
