class AddDateIndexToPriceUpdates < ActiveRecord::Migration[5.1]
  def change
    add_index :price_updates, :created_at
  end
end
