class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user, index: true
      t.string :city
      t.string :street
      t.string :postal_code
      t.string :complement	
      t.timestamps null: false
    end
  end
end
