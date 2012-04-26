class AddGamePlayedColumnToImDivisions < ActiveRecord::Migration
  def self.up
    add_column :im_divisions, :game_played, :boolean, :default => false
  end

  def self.down
  	remove_column :im_divisions, :game_played
  end
end
