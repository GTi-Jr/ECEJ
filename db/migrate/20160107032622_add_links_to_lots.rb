class AddLinksToLots < ActiveRecord::Migration
  def change
    add_column :lots, :link_fed, :string, default: ""
    add_column :lots, :link_unfed, :string, default: ""
  end
end
