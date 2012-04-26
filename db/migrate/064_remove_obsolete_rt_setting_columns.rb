class RemoveObsoleteRtSettingColumns < ActiveRecord::Migration
  def self.up
    remove_column :rt_settings, :team_add_games
    remove_column :rt_settings, :team_view_employees
  end

  def self.down
    add_column :rt_settings, :team_add_games, :boolean, :default => false
    add_column :rt_settings, :team_view_employees, :boolean, :default => false
  end
end
