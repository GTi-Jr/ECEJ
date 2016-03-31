class AddRoomImageToHotel < ActiveRecord::Migration
  def change
    add_column :hotels, :room_image, :string
  end
end
