class ItemsController < ApplicationController
  before_action :find_item
  def show
    @item = @item.decorate
    respond_to do |format|
      format.html
      format.json { render json: @item }
    end
  end

  def daily
    render json: @item.price_history(1)
  end

  def three
    render json: @item.price_history(3)
  end

  def week
    render json: @item.price_history(7)
  end

  def month
    render json: @item.price_history(30)
  end

  def favourite
    return head :unauthorized unless user_signed_in?
    if current_user.favourited? @item
      current_user.unfavourite @item
      head :ok
    else
      current_user.favourite @item
      head :created
    end
  end

  def refresh
    a = @item.get_past_month
    if a.class == 'String'
      redirect_to item_path(@item.runescape_id), alert: a
    else
      redirect_to item_path(@item.runescape_id), alert: 'Item updated! Cooldown: 1 hour'
    end
  end

  private

  def find_item
    @item = Item.find_by!(runescape_id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Item not found!'
  end
end
