class ItemDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def margin
    return "- gp" unless valid?
    format_gp(object.margin)
  end

  def roi_raw
    return "0 %" unless valid?
    roi = object.roi.round(2)
    "#{roi} %"
  end

  def valid?
    object.margin.abs != object.price.abs && object.margin != 0
  end

  def roi
    roi = object.roi.round(2)
    return if roi <= 0.01
    "(#{roi} %)"
  end

  def buy_price
    format_gp(object.buy_price)
  end

  def sell_price
    format_gp(object.sell_price)
  end

  def price
    format_gp(object.price)
  end

  def format_gp(value)
    h.number_to_currency(value, unit: 'gp', format: '%n %u', precision: 0)
  end

end
