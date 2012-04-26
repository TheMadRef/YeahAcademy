class UpdateDatabaseForImOnlineConversion < ActiveRecord::Migration
  def self.up
    change_column :participants, :last_update, :timestamp
    change_column :participants, :im_active, :boolean, { :default => false}
    add_column :im_sports, :exported, :boolean, :default => false
  end

  def self.down
    remove_column :im_sports, :exported
    change_column :participants, :last_update, :datetime
  end
end
