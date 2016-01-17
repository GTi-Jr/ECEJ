class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :street, :string
    add_column :users, :cep, :string
  end
end
