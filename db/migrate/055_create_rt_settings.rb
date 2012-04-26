class CreateRtSettings < ActiveRecord::Migration
  def self.up
    create_table :rt_settings do |t|
      t.column :system_name, :string
      t.column :welcome_message, :text
      t.column :last_schedule_date, :date
      t.column :default_start_time, :time
      t.column :default_game_length, :time
      t.column :scheduling_request_method, :boolean
      t.column :show_directions, :boolean
      t.column :team_add_games, :boolean
      t.column :team_view_employees, :boolean
      t.column :system_admin_name, :string
      t.column :system_admin_email, :string
      t.column :master_rt_terms_and_conditions, :boolean
      t.column :master_rt_terms_and_conditions_text, :text
    end
  end

  def self.down
    drop_table :rt_settings
  end
end
