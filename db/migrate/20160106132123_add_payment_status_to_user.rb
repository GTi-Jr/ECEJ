class AddPaymentStatusToUser < ActiveRecord::Migration
  def change
    add_column :users, :payment_status, :string
  end
end
