class ItemsController < ApplicationController
  before_action :find_item
  def show
    @q = Item.ransack(params[:q])
    @item = @item.decorate
  end

  def daily
    # render json: moving_average(@item.price_history(1))
    render json: @item.price_history(1)
  end

  def three
    # render json: moving_average(@item.price_history(3))
    render json: @item.price_history(3)
  end

  def week
    # render json: moving_average(@item.price_history(7))
    render json: @item.price_history(7)
  end

  def month
    # render json: moving_average(@item.price_history(30))
    render json: @item.price_history(30)
  end

  def moving_average(history, back = 5)
    a = []
    history.each_with_index do |d, i|
      if i < back - 1
        a << d
      else
        # c = (d[1] +
        #   history[i - 1][1] +
        #   history[i - 2][1] +
        #   history[i - 3][1] +
        #   history[i - 4][1]) / 5
        c = 0
        back.times do |n|
          c += history[i - n][1]
        end
        c /= back
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
    a = @item.get_past_month
    if a.class == "String"
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
