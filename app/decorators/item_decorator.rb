class ItemDecorator < ApplicationDecorator
  delegate_all

  def margin
    return '0 gp' unless valid?
    format_gp(object.margin.abs)
  end

  def updated
    "#{h.time_ago_in_words(object.updated_at)} ago"
  end

  def roi_raw
    return '0%' unless valid?
    roi = object.roi.round 4
    "#{roi * 100}%"
  end

  def valid?
    object.margin.abs != object.recommended_sell_price.abs && object.margin != 0
  end

  def traded
    h.number_to_human((buying_rate + selling_rate) / 2, format: '%n%u', units: { thousand: 'K', million: 'M', billion: 'B' })
  end

  def roi
    roi_raw
  end

  def buy_price
    format_gp(object.buy_price)
  end

  def sell_price
    format_gp(object.sell_price)
  end

  def recommended_buy
    format_gp(object.recommended_buy_price)
  end

  def recommended_sell
    format_gp(object.recommended_sell_price)
  end

  def price
    format_gp(object.price)
  end

  def format_gp(value)
    h.number_to_currency(value, unit: 'gp', format: '%n %u', precision: 0)
  end

  def margin_style
    object.margin != 0 ? 'light-green-text text-lighten-1' : 'red-text'
  end
end
