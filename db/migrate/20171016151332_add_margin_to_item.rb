class AddMarginToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :margin, :integer
    add_index :items, :margin
  end
end
