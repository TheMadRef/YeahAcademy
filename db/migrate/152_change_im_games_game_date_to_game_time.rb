class ChangeImGamesGameDateToGameTime < ActiveRecord::Migration
  def self.up
  	remove_column :im_games, :game_time
  	rename_column :im_games, :game_date, :game_time
	rename_column :im_games, :number_sets, :number_of_sets
  end

  def self.down
  	rename_column :im_games, :game_time, :game_date
  	add_column :im_games, :game_time, :date
	rename_column :im_games, :number_of_sets, :number_sets
  end
end
