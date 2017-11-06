class HomeController < ApplicationController
  def index
    @items = Item.positive_roi
    @items = @items.first(200) # limit it
    @items = sort_items_for_user(current_user, @items)
    @items = ItemDecorator.decorate_collection(@items)
  end

  def search
    name = params.require(:item).permit(:name)[:name]
    @search = true
    @items = Item.search name,
                         fields: [:name],
                         match: :word_start,
                         misspellings: { below: 5 }
    @items = @items.first 200
    sort_decorate_render_groups
  end

  def most_traded
    @items = Item.most_traded.to_a
    sort_decorate_render_groups
  end

  def top_flips
    @items = Item.top_flips.to_a
    @items = ItemDecorator.decorate_collection(@items)
    render 'index'
  end

  def sort_decorate_render_groups
    @items = sort_items_for_user(current_user, @items)
    @items = ItemDecorator.decorate_collection @items
    render 'index'
  end

  def barrows_items
    @items = Item.barrows_items.to_a
    sort_decorate_render_groups
  end

  def food
    @items = Item.food.to_a
    sort_decorate_render_groups
  end

  def zulrah
    @items = Item.zulrah.to_a
    sort_decorate_render_groups
  end

  def potions
    @items = Item.potions.to_a
    sort_decorate_render_groups
  end

  def ores
    @items = Item.ores.to_a
    sort_decorate_render_groups
  end

  def sort_items_for_user(user, items)
    user ||= User.new
    case user.sorting_method
    when 'roi'
      items.sort { |x, y| y.roi <=> x.roi }
    when 'traded'
      items.sort { |x, y| (y.buying_rate + y.selling_rate) <=> (x.buying_rate + x.selling_rate) }
    when 'margin'
      items.sort { |x, y| y.margin <=> x.margin }
    else # traded_roi
      items.sort { |x, y| y.roi.to_f * (y.buying_rate + y.selling_rate) <=> x.roi.to_f * (x.buying_rate + y.selling_rate) }
    end
  end
end
