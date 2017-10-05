class AddIndexesToItems < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :name
    add_index :items, :runescape_id
  end
end
