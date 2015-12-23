class CreateLots < ActiveRecord::Migration
  def change
    create_table :lots do |t|
      t.string :name
      t.integer :number
      t.integer :limit
      t.float :value_not_federated
      t.float :value_federated
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.timestamps null: false
    end
  end
end
