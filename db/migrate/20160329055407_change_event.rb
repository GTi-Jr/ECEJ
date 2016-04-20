class ChangeEvent < ActiveRecord::Migration
  def self.up
    rename_column :events, :start_time, :start
  	rename_column :events, :end_time, :end
  end

  def self.down
    rename_column :events, :start, :start_time
  	rename_column :events, :end, :end_time
  end
end
