class AddIndexForMembersToItem < ActiveRecord::Migration[5.1]
  def change
    add_index :items, :members
  end
end
