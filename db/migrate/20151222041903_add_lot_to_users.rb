class AddLotToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lot, :integer
  end
end
