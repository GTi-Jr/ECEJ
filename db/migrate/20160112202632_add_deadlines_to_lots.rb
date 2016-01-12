class AddDeadlinesToLots < ActiveRecord::Migration
  def change
    remove_column :lots, :payment_deadline
    add_column :lots, :deadline_1, :date
    add_column :lots, :deadline_2, :date
    add_column :lots, :deadline_3, :date
    add_column :lots, :deadline_4, :date
  end
end
