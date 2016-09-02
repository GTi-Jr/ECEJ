class AddFoodRestrictionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :food_restriction, :string
  end
end
