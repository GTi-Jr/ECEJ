class AddFederatedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :federated, :boolean
  end
end
