class AddEmaToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :recommended_buy_price, :decimal
    add_index :items, :recommended_buy_price
    add_column :items, :recommended_sell_price, :decimal
    add_index :items, :recommended_sell_price
  end
end
