class HomeController < ApplicationController
  def index
    @q = Item.ransack(params[:q])
    if params[:q].nil?
      @items = Item.all.sample(5)
    else
      @items = @q.result
    end
  end
end
