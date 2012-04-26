class CreateCtSessionSchedules < ActiveRecord::Migration
  def self.up
    create_table :ct_session_schedules do |t|
    	t.column :ct_session_id, :integer
	  	t.column :session_start_date, :datetime
	  	t.column :session_end_date, :datetime
	  	t.column :meet_monday, :boolean, :default => false
	  	t.column :meet_tuesday, :boolean, :default => false
	  	t.column :meet_wednesday, :boolean, :default => false
	  	t.column :meet_thursday, :boolean, :default => false
	  	t.column :meet_friday, :boolean, :default => false
	  	t.column :meet_saturday, :boolean, :default => false
	  	t.column :meet_sunday, :boolean, :default => false
	  	t.column :monday_start_time, :time, :default => "00:00:00"
	  	t.column :monday_end_time, :time, :default => "23:59:59"
	  	t.column :tuesday_start_time, :time, :default => "00:00:00"
	  	t.column :tuesday_end_time, :time, :default => "23:59:59"
	  	t.column :wednesday_start_time, :time, :default => "00:00:00"
	  	t.column :wednesday_end_time, :time, :default => "23:59:59"
	  	t.column :thursday_start_time, :time, :default => "00:00:00"
	  	t.column :thursday_end_time, :time, :default => "23:59:59"
	  	t.column :friday_start_time, :time, :default => "00:00:00"
	  	t.column :friday_end_time, :time, :default => "23:59:59"
	  	t.column :saturday_start_time, :time, :default => "00:00:00"
	  	t.column :saturday_end_time, :time, :default => "23:59:59"
	  	t.column :sunday_start_time, :time, :default => "00:00:00"
	  	t.column :sunday_end_time, :time, :default => "23:59:59"
	  	t.column :playing_area_id, :integer
    end
  end

  def self.down
    drop_table :ct_session_schedules
  end
end
