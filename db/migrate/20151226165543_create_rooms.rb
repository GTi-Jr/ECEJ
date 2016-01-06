class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :hotel
      t.integer :number
      t.integer :capacity
      t.text :extra_info

      t.timestamps null: false
    end
  end
end
