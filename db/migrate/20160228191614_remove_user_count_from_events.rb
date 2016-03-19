class RemoveUserCountFromEvents < ActiveRecord::Migration
  def change
    remove_column :events, :user_count, :integer
  end
end
