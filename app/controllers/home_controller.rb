class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = if params[:q].nil?
               # Item.all.sample(5)
               arr = []
               # items = Item.all
               items = Item.positive_roi
               repeat = 0
               items.sample(10)
               # loop do
               #   break if arr.count >= 5
               #   break if repeat > 50
               #   repeat += 1
               #   i = items.sample
               #   next if i.nil?
               #   # TODO: make these options?
               #   arr << i
               # end
               # arr
             else
               @search = true
               @q.result
             end
    @items = @items.first(50) # limit it
    @items.sort! { |x, y| y.roi.to_f * (y.buying_rate + y.selling_rate) <=> x.roi.to_f * (x.buying_rate + y.selling_rate) }
    @items = ItemDecorator.decorate_collection(@items)
  end

  def most_traded
    @q = Item.ransack(params[:q])
    @items = Item.most_traded.to_a
    @items.sort! { |x, y| y.roi.to_f <=> x.roi.to_f }
    @items = ItemDecorator.decorate_collection(@items)
    render 'index'
  end

  def top_flips
    @q = Item.ransack(params[:q])
    @items = Item.top_flips.to_a
    @items = ItemDecorator.decorate_collection(@items)
    render 'index'
  end
end
