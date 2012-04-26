class AddMasterSettingLogoutLink < ActiveRecord::Migration
  def self.up
  	add_column :master_settings, :logout_link, :string
  end

  def self.down
  	remove_column :master_settings, :logout_link
  end
end
