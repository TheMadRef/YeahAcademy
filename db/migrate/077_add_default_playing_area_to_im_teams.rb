class AddDefaultPlayingAreaToImTeams < ActiveRecord::Migration
  def self.up
    add_column :im_teams, :playing_area_id, :integer
  end

  def self.down
    remove_column :im_teams, :playing_area_id
  end
end
