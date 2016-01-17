class RemoveTransportRequiredToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :transport_required, :boolean
  end
end
