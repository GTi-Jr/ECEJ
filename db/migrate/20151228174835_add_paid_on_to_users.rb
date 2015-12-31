class AddPaidOnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paid_on, :datetime, default: nil
  end
end
