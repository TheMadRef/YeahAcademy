class AddRtEmployeeTurnbackColumnToRtEmployeeCalendar < ActiveRecord::Migration
  def self.up
  	add_column :rt_employee_calendars, :rt_employee_turnback_id, :integer
  end

  def self.down
  	remove_column :rt_employee_calendars, :rt_employee_turnback_id
  end
end
