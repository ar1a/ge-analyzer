class AddRoiToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :roi, :decimal
    add_index :items, :roi
  end
end
