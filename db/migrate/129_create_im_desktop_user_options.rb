class CreateImDesktopUserOptions < ActiveRecord::Migration
  def self.up
    create_table :im_desktop_user_options do |t|
    	t.column :desktop_user_id, :integer
    	t.column :change, :boolean
    	t.column :add_area, :boolean
    	t.column :add_facility, :boolean
    	t.column :add_sport, :boolean
    	t.column :add_term, :boolean
    	t.column :add_user, :boolean
    	t.column :admin, :boolean
    	t.column :change_password, :boolean
    	t.column :color_scheme, :boolean
    	t.column :database, :boolean
    	t.column :delete_area, :boolean
    	t.column :delete_facility, :boolean
    	t.column :delete_sport, :boolean
    	t.column :delete_term, :boolean
    	t.column :delete_user, :boolean
    	t.column :edit_area, :boolean
    	t.column :edit_facility, :boolean
    	t.column :edit_sport, :boolean
    	t.column :edit_term, :boolean
    	t.column :edit_user, :boolean
    	t.column :frames_setup, :boolean
    	t.column :maintenance, :boolean
    	t.column :options, :boolean
    	t.column :security, :boolean
    	t.column :serial_numbers, :boolean
    	t.column :view_calendar, :boolean
    	t.column :web_settings, :boolean
    	t.column :add_division, :boolean
    	t.column :add_league_score, :boolean
    	t.column :delete_division, :boolean
    	t.column :delete_league_score, :boolean
    	t.column :edit_division, :boolean
    	t.column :edit_league_score, :boolean
    	t.column :league_play, :boolean
    	t.column :add_bracket, :boolean
    	t.column :add_bracket_score, :boolean
    	t.column :delete_bracket, :boolean
    	t.column :delete_bracket_score, :boolean
    	t.column :edit_bracket, :boolean
    	t.column :edit_bracket_score, :boolean
    	t.column :bracket_play, :boolean
    	t.column :add_participant, :boolean
    	t.column :add_roster, :boolean
    	t.column :change_eligibility, :boolean
    	t.column :delete_participant, :boolean
    	t.column :delete_roster, :boolean
    	t.column :edit_participant, :boolean
    	t.column :participant, :boolean
    	t.column :participant_search, :boolean
    	t.column :add_client_area, :boolean
    	t.column :add_dop, :boolean
    	t.column :add_client_facility, :boolean
    	t.column :add_league, :boolean
    	t.column :delete_client_area, :boolean
    	t.column :delete_dop, :boolean
    	t.column :edit_client_facility, :boolean
    	t.column :edit_league, :boolean
    	t.column :client_maintenance, :boolean
    	t.column :new_season, :boolean
    	t.column :view_client_calendar, :boolean
    	t.column :client_color_scheme, :boolean
    	t.column :printing, :boolean
    	t.column :view_pages, :boolean
    	t.column :client_web_pages, :boolean
    end
  end

  def self.down
    drop_table :im_desktop_user_options
  end
end
