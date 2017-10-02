class HomeController < ApplicationController
  def index
    @items = Item.first(20).sample(3)
  end
end
