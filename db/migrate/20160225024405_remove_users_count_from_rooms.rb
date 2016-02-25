class RemoveUsersCountFromRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :user_count, :integer
  end
end
