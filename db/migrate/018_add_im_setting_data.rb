class AddImSettingData < ActiveRecord::Migration
	def self.up
		ImSetting.delete_all
		ImSetting.create(:captain_limit_per_division => 99,
        :captain_limit_per_league => 99,
		:captain_limit_per_sport => 99,
		:overall_captain_limit => 99,
		:participant_roster_limit_per_sport => 99,
		:participant_roster_limit_per_league => 99,
		:captain_cards => false,
		:system_name => 'IMOnline Registration',
		:free_agents => false,
		:verify_im_eligibility => false,
		:welcome_message => 'Online Registration System',
		:default_page => 'teams',
		:allow_multiple_colors => false,
		:last_member_export => Date.today,
		:master_im_terms_and_conditions => false,
		:master_im_terms_and_conditions_text => 'The master terms and conditions option makes it mandatory for all participants to accept the conditions listed on this text field  before being able to buy or join a team.  Thus, the admin can only add a team if the captain has already signed the terms and conditions.  Likewise, the admin can only add a player to a roster if the conditions are signed.  Edit this text to specify your master terms and conditions.',
		:team_terms_and_conditions => false,
		:team_terms_and_conditions_text => 'The team terms and conditions option makes it mandatory for team captains to accept the conditions listed on this text field before being able to buy a tam.  Therefore, the admin can not add new teams to the system because each individual captain must sign the terms and conditions. Edit this text to specify your team terms and conditions.',
		:roster_terms_and_conditions => false,
		:roster_terms_and_conditions_text => 'The roster terms and conditions option makes it mandatory for all participants to accept the conditions listed on this text field before being able to join a team.  Therefore, the admin can not add any players to team rosters because each individual must sign the terms and conditions in order to be added to the roster. Edit this text to specify your team terms and conditions.')
	end

	def self.down
		ImSetting.delete_all
	end
end
