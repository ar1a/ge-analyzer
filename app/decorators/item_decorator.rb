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
    return '- gp' unless valid?
    format_gp(object.margin)
  end

  def roi_raw
    return '0 %' unless valid?
    roi = object.roi.round 4
    "#{roi * 100} %"
  end

  def valid?
    object.margin.abs != object.price.abs && object.margin != 0
  end

  def traded
    (buying_rate + selling_rate) / 2
  end

  def roi
    return '(0 %)' if object.roi.nil?
    roi = object.roi.round 4
    return if roi <= 0.0001 || roi.nan?
    "(#{roi * 100} %)"
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

  def margin_style
    return 'negative' if object.roi.nil?
    object.roi.round(4) > 0.0001 ? 'positive' : 'negative'
  end
end
