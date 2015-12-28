class AddPaymentDeadlineToLot < ActiveRecord::Migration
  def change
    add_column :lots, :payment_deadline, :datetime
  end
end
