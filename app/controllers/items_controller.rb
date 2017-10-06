class ItemsController < ApplicationController
  before_action :find_item
  def show; end

  def daily
    render json: @item.price_history(1)
  end

  private

  def find_item
    @item = Item.find_by(runescape_id: params[:id])
  end
end
