class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = if params[:q].nil?
               Item.all.sample(5)
             else
               @q.result
             end
  end
end
