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
    format_gp(object.margin)
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
