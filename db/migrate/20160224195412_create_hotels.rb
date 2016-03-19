class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
    	t.string :name, default: ""
    	t.string :extra_info, default: ""

      t.timestamps null: false
    end
  end
end
