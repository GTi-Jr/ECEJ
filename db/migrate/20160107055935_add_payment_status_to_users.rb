class AddPaymentStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment_status, :string, default: "Não processado"
  end
end
