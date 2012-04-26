class AddDatabaseVersionToMasterSettings < ActiveRecord::Migration
  def self.up
  	add_column :master_settings, :database_version, :integer, :default => 0
  end

  def self.down
  	remove_column :master_settings, :database_version
  end
end
