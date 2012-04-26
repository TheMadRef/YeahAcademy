class AddNewMasterSettingColumns < ActiveRecord::Migration
  def self.up
      add_column :master_settings, :system_name, :string, :default => "Facilitrax by Recreational Solutions"
      add_column :master_settings, :welcome_message, :text
      add_column :master_settings, :customer_id, :string, :default => "test"
  end

  def self.down
    remove_column :master_settings, :system_name
    remove_column :master_settings, :welcome_message
    remove_column :master_settings, :customer_id
  end
end
