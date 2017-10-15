class AddRoiToPriceUpdate < ActiveRecord::Migration[5.1]
  def change
    add_column :price_updates, :roi, :decimal
    add_index :price_updates, :roi
  end
end
