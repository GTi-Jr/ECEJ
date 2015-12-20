class AddUserAtributes < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
    	t.string :name
    	t.string :general_register
    	t.string :cpf
    	t.date :nasc_date
    	t.string :gender
    	t.attachment :avatar
    	t.string :telephone
    	t.string :federation
    	t.string :junior_enteprise
    	t.string :enterprise_office
    	t.string :university
    	t.boolean :special_needs
    end
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
