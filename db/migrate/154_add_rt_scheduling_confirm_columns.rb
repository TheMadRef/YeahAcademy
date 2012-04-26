class AddRtSchedulingConfirmColumns < ActiveRecord::Migration
  def self.up
  	add_column :rt_settings, :send_game_notification_emails, :boolean, :default => false
  	add_column :rt_settings, :require_game_acceptance, :boolean, :default => false
		add_column :rt_settings, :automatically_publish_assignments, :boolean, :default => false
  	add_column :rt_employee_schedules, :status, :integer, :default => 0
  end

  def self.down
  	remove_column :rt_settings, :send_game_notification_emails
  	remove_column :rt_settings, :require_game_acceptance
		remove_column :rt_settings, :automatically_publish_assignments
  	remove_column :rt_employee_schedules, :status
  end
end
