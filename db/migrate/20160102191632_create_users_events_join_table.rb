class CreateUsersEventsJoinTable < ActiveRecord::Migration
  def change
    create_table :users_events, id: false do |t|
      t.integer :user_id
      t.integer :event_id
    end
  end
end
