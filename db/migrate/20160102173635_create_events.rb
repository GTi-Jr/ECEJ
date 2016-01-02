class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, default: ""
      t.string :facilitator, default: ""
      t.integer :limit, default: 1
      t.datetime :start, defaul: nil
      t.datetime :end, default: nil

      t.timestamps null: false
    end
  end
end
