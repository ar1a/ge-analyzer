class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    @items = @q.result unless q.nil?
    @items = Item.all.sample(5) if q.nil?
  end
end
