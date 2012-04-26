class RtEmployeeCalendar < ActiveRecord::Base
  belongs_to :participant
  belongs_to :rt_participant_out_date
	belongs_to :rt_employee_schedule
	belongs_to :rt_employee_turnback
end
