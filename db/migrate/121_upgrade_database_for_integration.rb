class UpgradeDatabaseForIntegration < ActiveRecord::Migration
  def self.up
  	add_column :categories, :block_code, :string
  	add_column :categories, :participant_limit, :integer
  	add_column :categories, :number_of_participants, :boolean
  	add_column :categories, :added_by, :string
  	add_column :facilities, :facility_abbreviation, :string
  	add_column :facilities, :pool, :boolean
  	add_column :facilities, :number_of_lanes, :integer
  	add_column :facilities, :default_length, :integer
  	add_column :facilities, :default_unit, :integer
  	add_column :facilities, :time_frame_range, :integer
  	add_column :facilities, :added_by, :string
		add_column :im_day_of_plays, :game_sets, :integer
		add_column :im_day_of_plays, :frequency, :integer
		add_column :im_day_of_plays, :sunday, :boolean
		add_column :im_day_of_plays, :monday, :boolean
		add_column :im_day_of_plays, :tuesday, :boolean
		add_column :im_day_of_plays, :wednesday, :boolean
		add_column :im_day_of_plays, :thursday, :boolean
		add_column :im_day_of_plays, :friday, :boolean
		add_column :im_day_of_plays, :saturday, :boolean
		add_column :im_day_of_plays, :start_date, :datetime
		add_column :im_divisions, :game_sets, :integer
		add_column :im_divisions, :game_length_hour, :integer
		add_column :im_divisions, :game_length_minute, :integer
		add_column :im_divisions, :scheduled, :boolean
		add_column :im_divisions, :schedule_type, :integer
		add_column :im_divisions, :setting, :integer
		add_column :im_divisions, :manual_sort, :boolean
		add_column :im_games, :im_bracket_id, :integer
		rename_column :im_games, :home_sr, :home_sportsmanship
		rename_column :im_games, :away_sr, :away_sportsmanship
		rename_column :im_games, :next_playoff_game, :next_playoff_game_id
		rename_column :im_games, :next_playoff_game_l, :next_playoff_game_l_id
		add_column :im_games, :reservation_id, :integer
		add_column :im_games, :added_by, :string
		add_column :im_sports, :sport_model, :string
		add_column :im_sports, :scoring_model, :integer
		add_column :im_sports, :sportsmanship, :boolean
		add_column :im_sports, :minimum_sportsmanship, :decimal, :precision => 8, :scale => 2
		rename_column :im_sports, :require_color, :jersey_color
		add_column :im_sports, :no_show_limit, :boolean
		add_column :im_sports, :no_show_count, :integer
		add_column :im_sports, :participants, :boolean
		add_column :im_sports, :statistics, :boolean
		add_column :im_sports, :show_rankings, :boolean
		add_column :im_sports, :print_rankings, :boolean
		add_column :im_sports, :sort_heading_1, :string
		add_column :im_sports, :sorting_1, :integer
		add_column :im_sports, :sort_heading_2, :string
		add_column :im_sports, :sorting_2, :integer
		add_column :im_sports, :sort_heading_3, :string
		add_column :im_sports, :sorting_3, :integer
		add_column :im_sports, :statistics_table, :string
		add_column :im_sports, :gamesheet_control_id, :integer	
		add_column :im_sports, :scorecard_control_id, :integer
		add_column :im_sports, :last_accessed, :datetime
		add_column :im_sports, :last_web_creation, :datetime
		add_column :im_sports, :create_sport_pages, :boolean
		add_column :im_sports, :sport_link, :boolean
		add_column :im_sports, :bracket_link, :boolean
		add_column :im_sports, :daily_link, :boolean
		add_column :im_sports, :god_link, :boolean
		add_column :im_sports, :league_link, :boolean
		add_column :im_sports, :top_ten_link, :boolean
		add_column :im_sports, :stat_top_link, :boolean
		add_column :im_sports, :stat_all_link, :boolean
		add_column :im_teams, :games, :integer
		add_column :im_teams, :wins, :integer
		add_column :im_teams, :losses, :integer
		add_column :im_teams, :ties, :integer
		add_column :im_teams, :forfiets, :integer
		add_column :im_teams, :no_shows, :integer
		add_column :im_teams, :winning_percentage, :decimal, :precision => 8, :scale => 2
		add_column :im_teams, :percentage_bonus, :integer
		add_column :im_teams, :win_bonus, :integer
		add_column :im_teams, :offense, :integer
		add_column :im_teams, :offense_bonus, :integer
		add_column :im_teams, :defense, :integer
		add_column :im_teams, :defense_bonus, :integer
		add_column :im_teams, :sportsmanship, :decimal, :precision => 8, :scale => 2
		add_column :im_teams, :sportsmanship_average, :decimal, :precision => 8, :scale => 2
		add_column :im_teams, :sportsmanship_bonus, :integer
		add_column :im_teams, :points_allowed, :integer
		add_column :im_teams, :points_allowed_bonus, :integer
		add_column :im_teams, :points_scored, :integer
		add_column :im_teams, :points_scored_bonus, :integer
		add_column :im_teams, :misc_bonus, :integer
		add_column :im_teams, :rating, :decimal, :precision => 8, :scale => 2
		add_column :im_teams, :rating_average, :decimal, :precision => 8, :scale => 2
		add_column :im_teams, :ranking, :integer
		add_column :im_teams, :points, :integer
		add_column :im_teams, :place, :integer
		add_column :participants, :card_number, :string
		add_column :participants, :participant_title_id, :integer
		rename_column :participants, :DOB, :date_of_birth
		add_column :participants, :work_phone, :string
		add_column :participants, :mobile_phone, :string
		add_column :participants, :fax, :string
		add_column :participants, :emergency_name, :string
		add_column :participants, :emergency_phone, :string
		add_column :participants, :job_title, :string
		add_column :participants, :mail_code, :string
		add_column :participants, :comments, :text
		add_column :participants, :contract_unit, :string
		add_column :participants, :contract_length, :string
		add_column :participants, :start_date, :datetime
		add_column :participants, :end_date, :datetime
		add_column :participants, :head_of_household, :boolean
		add_column :participants, :added_by, :string
		add_column :participants, :organization, :boolean
		add_column :participants, :allow_members, :boolean
		add_column :participants, :organization_category_id, :integer
		add_column :participants, :modified_date, :datetime
		add_column :playing_areas, :allow_consecutive, :boolean
		add_column :playing_areas, :allow_multiple, :boolean
		add_column :playing_areas, :approval, :boolean
		add_column :playing_areas, :check_in, :boolean
		add_column :playing_areas, :alarm, :boolean
		add_column :playing_areas, :added_by, :string
		add_column :playing_areas, :sub_area, :boolean
  end

  def self.down
  	remove_column :categories, :block_code
  	remove_column :categories, :participant_limit
  	remove_column :categories, :number_of_participants
  	remove_column :categories, :added_by
  	remove_column :facilities, :facility_abbreviation
  	remove_column :facilities, :pool
  	remove_column :facilities, :number_of_lanes
  	remove_column :facilities, :default_length
  	remove_column :facilities, :default_unit
  	remove_column :facilities, :time_frame_range
  	remove_column :facilities, :added_by
  	remove_column :im_day_of_plays, :game_sets
  	remove_column :im_day_of_plays, :frequency
  	remove_column :im_day_of_plays, :sunday
  	remove_column :im_day_of_plays, :monday
  	remove_column :im_day_of_plays, :tuesday
  	remove_column :im_day_of_plays, :wednesday
  	remove_column :im_day_of_plays, :thursday
  	remove_column :im_day_of_plays, :friday
  	remove_column :im_day_of_plays, :saturday
  	remove_column :im_day_of_plays, :start_date
  	remove_column :im_divisions, :game_sets
  	remove_column :im_divisions, :game_length_hour
  	remove_column :im_divisions, :game_length_minute
  	remove_column :im_divisions, :scheduled
  	remove_column :im_divisions, :schedule_type
  	remove_column :im_divisions, :setting
  	remove_column :im_divisions, :manual_sort
  	remove_column :im_games, :im_bracket_id
		rename_column :im_games, :home_sportsmanship, :home_sr
		rename_column :im_games, :away_sportsmanship, :away_sr
		rename_column :im_games, :next_playoff_game_id, :next_playoff_game
		rename_column :im_games, :next_playoff_game_l_id, :next_playoff_game_l
	 	remove_column :im_games, :reservation_id
  	remove_column :im_games, :added_by
		remove_column :im_sports, :sport_model
		remove_column :im_sports, :scoring_model
		remove_column :im_sports, :sportsmanship
		remove_column :im_sports, :minimum_sportsmanship
		rename_column :im_sports, :jersey_color, :require_color
		remove_column :im_sports, :no_show_limit
		remove_column :im_sports, :no_show_count
		remove_column :im_sports, :participants
		remove_column :im_sports, :statistics
		remove_column :im_sports, :show_rankings
		remove_column :im_sports, :print_rankings
		remove_column :im_sports, :sort_heading_1
		remove_column :im_sports, :sorting_1
		remove_column :im_sports, :sort_heading_2
		remove_column :im_sports, :sorting_2
		remove_column :im_sports, :sort_heading_3
		remove_column :im_sports, :sorting_3
		remove_column :im_sports, :statistics_table
		remove_column :im_sports, :gamesheet_control_id
		remove_column :im_sports, :scorecard_control_id
		remove_column :im_sports, :last_accessed
		remove_column :im_sports, :last_web_creation
		remove_column :im_sports, :create_sport_pages
		remove_column :im_sports, :sport_link
		remove_column :im_sports, :bracket_link
		remove_column :im_sports, :daily_link
		remove_column :im_sports, :god_link
		remove_column :im_sports, :league_link
		remove_column :im_sports, :top_ten_link
		remove_column :im_sports, :stat_top_link
		remove_column :im_sports, :stat_all_link
		remove_column :im_teams, :games
		remove_column :im_teams, :wins
		remove_column :im_teams, :losses
		remove_column :im_teams, :ties
		remove_column :im_teams, :forfiets
		remove_column :im_teams, :no_shows
		remove_column :im_teams, :winning_percentage
		remove_column :im_teams, :percentage_bonus
		remove_column :im_teams, :win_bonus
		remove_column :im_teams, :offense
		remove_column :im_teams, :offense_bonus
		remove_column :im_teams, :defense
		remove_column :im_teams, :defense_bonus
		remove_column :im_teams, :sportsmanship
		remove_column :im_teams, :sportsmanship_average
		remove_column :im_teams, :sportsmanship_bonus
		remove_column :im_teams, :points_allowed
		remove_column :im_teams, :points_allowed_bonus
		remove_column :im_teams, :points_scored
		remove_column :im_teams, :points_scored_bonus
		remove_column :im_teams, :misc_bonus
		remove_column :im_teams, :rating
		remove_column :im_teams, :rating_average
		remove_column :im_teams, :ranking
		remove_column :im_teams, :points
		remove_column :im_teams, :place
		remove_column :participants, :card_number
		remove_column :participants, :participant_title_id
		rename_column :participants, :date_of_birth, :DOB
		remove_column :participants, :work_phone
		remove_column :participants, :mobile_phone
		remove_column :participants, :fax
		remove_column :participants, :emergency_name
		remove_column :participants, :emergency_phone
		remove_column :participants, :job_title
		remove_column :participants, :mail_code
		remove_column :participants, :comments
		remove_column :participants, :contract_unit
		remove_column :participants, :contract_length
		remove_column :participants, :start_date
		remove_column :participants, :end_date
		remove_column :participants, :head_of_household
		remove_column :participants, :added_by
		remove_column :participants, :organization
		remove_column :participants, :allow_members
		remove_column :participants, :organization_category_id
		remove_column :participants, :modified_date
		remove_column :playing_areas, :allow_consecutive
		remove_column :playing_areas, :allow_multiple
		remove_column :playing_areas, :approval
		remove_column :playing_areas, :check_in
		remove_column :playing_areas, :alarm
		remove_column :playing_areas, :added_by
		remove_column :playing_areas, :sub_area
  end
end
