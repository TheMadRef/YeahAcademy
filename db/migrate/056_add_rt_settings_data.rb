class AddRtSettingsData < ActiveRecord::Migration
  def self.up
    RtSetting.delete_all
    RtSetting.create(:system_name => 'RefTrack Online Employee Scheduling',
              :welcome_message => 'Welcome to RefTrack Online Version 2',
              :last_schedule_date => Time.now, 
              :default_start_time => '20:00',
              :default_game_length => '1:00',
              :scheduling_request_method => false,
              :show_directions => false,
              :team_add_games => false,
              :team_view_employees => false,
              :system_admin_name => 'RefTrack Administrator',
              :system_admin_email => 'admin@yourprogram.edu',
              :master_rt_terms_and_conditions => false,
              :master_rt_terms_and_conditions_text => 'fill in terms and conditions you wish your employees to accept before being eligible to accept assignments')
 end
 
 def self.down
  RtSetting.delete_all
 end
end
