class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = if params[:q].nil?
               Item.all.sample(5)
             else
               @search = true
               @q.result
             end
    @items = ItemDecorator.decorate_collection(@items)
  end
end
