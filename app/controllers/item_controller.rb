class ItemController < ApplicationController
  def show
    @item = Item.find_by(runescape_id: params[:id])
  end
end
