class RemoveRtSettingDefaultGameLength < ActiveRecord::Migration
  def self.up
    remove_column :rt_settings, :default_game_length
  end

  def self.down
    add_column :rt_settings, :default_game_length, :time
  end
end
