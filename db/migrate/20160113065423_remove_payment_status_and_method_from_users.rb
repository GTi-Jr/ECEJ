class RemovePaymentStatusAndMethodFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :payment_status
    remove_column :users, :payment_method
  end
end
