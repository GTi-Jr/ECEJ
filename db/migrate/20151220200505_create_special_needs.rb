class CreateSpecialNeeds < ActiveRecord::Migration
  def change
    create_table :special_needs do |t|
      t.belongs_to :user, index: true
      t.string :name
      t.text :description
      t.timestamps null: false
    end
  end
end
