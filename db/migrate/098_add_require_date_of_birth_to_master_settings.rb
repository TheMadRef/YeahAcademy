class AddRequireDateOfBirthToMasterSettings < ActiveRecord::Migration
  def self.up
  	add_column :master_settings, :require_DOB, :boolean, :default => false
  end

  def self.down
  	remove_column :master_settings, :require_DOB	
  end
end
