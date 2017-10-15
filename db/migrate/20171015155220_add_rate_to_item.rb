class AddRateToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :buying_rate, :integer
    add_index :items, :buying_rate
    add_column :items, :selling_rate, :integer
    add_index :items, :selling_rate
  end
end
