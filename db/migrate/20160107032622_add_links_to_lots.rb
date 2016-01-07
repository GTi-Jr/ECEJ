class AddLinksToLots < ActiveRecord::Migration
  def change
    add_column :lots, :link_fed, :string
    add_column :lots, :link_unfed, :string
  end
end
