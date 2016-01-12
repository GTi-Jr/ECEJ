class AddDeadlinesToLots < ActiveRecord::Migration
  def change
    remove_column :lots, :payment_deadline, :datetime
    add_column :lots, :deadline_1, :datetime
    add_column :lots, :deadline_2, :datetime
    add_column :lots, :deadline_3, :datetime
    add_column :lots, :deadline_4, :datetime
  end
end
