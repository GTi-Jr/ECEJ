class AddTransportRequiredStringToUsers < ActiveRecord::Migration
  def change
    add_column :users, :transport_required, :string, default: "Não"
  end
end
