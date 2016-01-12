class AddNewLinksToLots < ActiveRecord::Migration
  def change
    remove_column :lots, :link_unfed
    remove_column :lots, :link_fed

    add_column :lots, :link_1_1_fed, :string, default: ""
    add_column :lots, :link_2_1_fed, :string, default: ""
    add_column :lots, :link_2_2_fed, :string, default: ""
    add_column :lots, :link_3_1_fed, :string, default: ""
    add_column :lots, :link_3_2_fed, :string, default: ""
    add_column :lots, :link_3_3_fed, :string, default: ""
    add_column :lots, :link_4_1_fed, :string, default: ""
    add_column :lots, :link_4_2_fed, :string, default: ""
    add_column :lots, :link_4_3_fed, :string, default: ""
    add_column :lots, :link_4_4_fed, :string, default: ""
    add_column :lots, :link_1_1_unfed, :string, default: ""
    add_column :lots, :link_2_1_unfed, :string, default: ""
    add_column :lots, :link_2_2_unfed, :string, default: ""
    add_column :lots, :link_3_1_unfed, :string, default: ""
    add_column :lots, :link_3_2_unfed, :string, default: ""
    add_column :lots, :link_3_3_unfed, :string, default: ""
    add_column :lots, :link_4_1_unfed, :string, default: ""
    add_column :lots, :link_4_2_unfed, :string, default: ""
    add_column :lots, :link_4_3_unfed, :string, default: ""
    add_column :lots, :link_4_4_unfed, :string, default: ""
  end
end
