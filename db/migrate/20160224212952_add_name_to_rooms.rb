class AddNameToRooms < ActiveRecord::Migration
  def change
  	add_column :rooms, :name, :string, default: ""
  end
end
