class AddLotToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lot, :integer, default: nil
  end
end
