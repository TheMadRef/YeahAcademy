class AddDefaultGameLengthColumnToImSports < ActiveRecord::Migration
  def self.up
    add_column :im_sports, :default_hour, :integer, :default => 1
    add_column :im_sports, :default_minute, :integer, :default => 0
  end

  def self.down
    remove_column :im_sports, :default_minute
    remove_column :im_sports, :default_hour
  end
end
