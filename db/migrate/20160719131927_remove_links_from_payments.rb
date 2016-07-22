class RemoveLinksFromPayments < ActiveRecord::Migration
  def change
    remove_column :payments, :link_1, :string
    remove_column :payments, :link_2, :string
    remove_column :payments, :link_3, :string
    remove_column :payments, :link_4, :string
  end
end
