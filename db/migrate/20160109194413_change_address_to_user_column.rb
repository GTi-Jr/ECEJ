class ChangeAddressToUserColumn < ActiveRecord::Migration
  def self.up
    drop_table :addresses
    add_column :users, :addres, :text
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
