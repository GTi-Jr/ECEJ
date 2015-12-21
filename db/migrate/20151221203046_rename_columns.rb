class RenameColumns < ActiveRecord::Migration
  def self.up
    rename_column :users, :nasc_date, :birthday
    rename_column :users, :enterprise_office, :job
    rename_column :users, :telephone, :phone
    rename_column :users, :junior_enteprise, :junior_enterprise
    remove_column :users, :special_needs
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
