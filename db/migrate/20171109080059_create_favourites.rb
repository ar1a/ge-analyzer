class CreateFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.integer :item_id

      t.timestamps
    end

    add_index :favourites, :user_id
    add_index :favourites, :item_id
    add_index :favourites, %i[user_id item_id], unique: true
  end
end
