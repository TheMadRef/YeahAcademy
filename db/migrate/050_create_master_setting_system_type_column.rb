class CreateMasterSettingSystemTypeColumn < ActiveRecord::Migration
  def self.up
    add_column :master_settings, :require_member_number, :boolean, :default => false
  end

  def self.down
    remove_column :master_settings, :require_member_number
  end
end
