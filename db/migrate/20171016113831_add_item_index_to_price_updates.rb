class AddItemIndexToPriceUpdates < ActiveRecord::Migration[5.1]
  def change
    add_index :price_updates, :item_id
  end
end
