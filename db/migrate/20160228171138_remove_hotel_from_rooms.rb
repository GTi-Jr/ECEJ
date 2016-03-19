class RemoveHotelFromRooms < ActiveRecord::Migration
  def change
    remove_column :rooms, :hotel, :string
  end
end
