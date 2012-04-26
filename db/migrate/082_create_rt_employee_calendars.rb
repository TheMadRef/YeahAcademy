class CreateRtEmployeeCalendars < ActiveRecord::Migration
  def self.up
    create_table :rt_employee_calendars do |t|
      t.column :participant_id, :integer
      t.column :rt_participant_out_date_id, :integer
      t.column :rt_employee_schedule_id, :integer
    end
  end

  def self.down
    drop_table :rt_employee_calendars
  end
end
