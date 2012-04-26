class UpdateDatabaseWithColumnsMissedOnMigration121 < ActiveRecord::Migration
  def self.up
  	add_column :im_desktop_user_options, :delete_client_facility, :boolean
  	add_column :im_desktop_user_options, :delete_league, :boolean
  	add_column :im_desktop_user_options, :edit_client_area, :boolean
  	add_column :im_desktop_user_options, :edit_dop, :boolean
		rename_column :im_serial_numbers, :desktop_user_id, :im_user_id
		rename_column :playing_areas, :abbreviation, :area_abbreviation
		rename_column :im_games, :visiting_team_id, :away_team_id
		add_column :im_games, :game_time, :time
  end

  def self.down
  	remove_column :im_desktop_user_options, :delete_client_facility
  	remove_column :im_desktop_user_options, :delete_league
  	remove_column :im_desktop_user_options, :edit_client_area
  	remove_column :im_desktop_user_options, :edit_dop
		rename_column :im_serial_numbers, :im_user_id, :desktop_user_id
		rename_column :playing_areas, :area_abbreviation, :abbreviation
		rename_column :im_games, :away_team_id, :visiting_team_id
		remove_column :im_games, :game_time
  end
end
