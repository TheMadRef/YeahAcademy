class AddDefaultTeamColumnToImTeams < ActiveRecord::Migration
  def self.up
    add_column :im_teams, :default_team, :boolean, :default => false
  end

  def self.down
    remove_column :im_teams, :default_team
  end
end
