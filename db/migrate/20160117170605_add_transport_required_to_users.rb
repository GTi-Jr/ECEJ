class AddTransportRequiredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :transport_required, :boolean, default: false
  end
end
