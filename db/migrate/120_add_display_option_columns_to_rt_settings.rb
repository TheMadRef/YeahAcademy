class AddDisplayOptionColumnsToRtSettings < ActiveRecord::Migration
  def self.up
  	add_column :rt_settings, :allow_team_blocks, :boolean, :default => false
  	add_column :rt_settings, :allow_facility_blocks, :boolean, :default => false
  end

  def self.down
  	remove_column :rt_settings, :allow_team_blocks
  	remove_column :rt_settings, :allow_facility_blocks
  end
end
