class HomeController < ApplicationController
  def index
    @items = Item.all.sample(5)
  end
end
