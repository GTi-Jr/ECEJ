class AddBlueprintToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :blueprint, :string
  end
end
