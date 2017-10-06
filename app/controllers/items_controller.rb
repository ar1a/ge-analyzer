class ItemsController < ApplicationController
  before_action :find_item
  def show; end

  def daily
    render json: moving_average(@item.price_history(1))
  end

  def three
    render json: moving_average(@item.price_history(3))
  end

  def week
    render json: moving_average(@item.price_history(7))
  end

  def month
    render json: moving_average(@item.price_history(30))
  end

  def moving_average(history)
    a = []
    history.each_with_index do |d, i|
      if i < 4
        a << d
      else
        c = (d[1] +
          history[i - 1][1] +
          history[i - 2][1] +
          history[i - 3][1] +
          history[i - 4][1]) / 5
        a << [d[0], c.to_i]
      end
    end
    [
      {
        name: 'Price',
        data: history
      },
      {
        name: 'Average',
        data: a
      }
    ]
  end

  def refresh
    @item.get_past_month
    redirect_to item_path(@item.runescape_id), alert: 'Item updated! Cooldown: 1 hour'
  end

  private

  def find_item
    @item = Item.find_by!(runescape_id: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Item not found!'
  end
end
