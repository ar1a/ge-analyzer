class AddMembersToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :members, :boolean, default: true
  end
end
