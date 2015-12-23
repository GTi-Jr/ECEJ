class RenameLotToLotIdInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :lot, :lot_id
  end
end
