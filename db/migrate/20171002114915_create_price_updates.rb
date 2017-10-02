class CreatePriceUpdates < ActiveRecord::Migration[5.1]
  def change
    create_table :price_updates do |t|
      t.integer :buy_average
      t.integer :sell_average
      t.integer :overall_average
      t.integer :item_id

      t.timestamps
    end
  end
end
