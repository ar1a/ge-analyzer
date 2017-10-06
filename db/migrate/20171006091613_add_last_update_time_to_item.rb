class AddLastUpdateTimeToItem < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :last_update_time, :datetime
  end
end
