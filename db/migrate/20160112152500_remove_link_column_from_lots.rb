class RemoveLinkColumnFromLots < ActiveRecord::Migration
  def change
    remove_column :lots, :link_1_1_fed
    remove_column :lots, :link_2_1_fed
    remove_column :lots, :link_2_2_fed
    remove_column :lots, :link_3_1_fed
    remove_column :lots, :link_3_2_fed
    remove_column :lots, :link_3_3_fed
    remove_column :lots, :link_4_1_fed
    remove_column :lots, :link_4_2_fed
    remove_column :lots, :link_4_3_fed
    remove_column :lots, :link_4_4_fed
    remove_column :lots, :link_1_1_unfed
    remove_column :lots, :link_2_1_unfed
    remove_column :lots, :link_2_2_unfed
    remove_column :lots, :link_3_1_unfed
    remove_column :lots, :link_3_2_unfed
    remove_column :lots, :link_3_3_unfed
    remove_column :lots, :link_4_1_unfed
    remove_column :lots, :link_4_2_unfed
    remove_column :lots, :link_4_3_unfed
    remove_column :lots, :link_4_4_unfed
  end
end
