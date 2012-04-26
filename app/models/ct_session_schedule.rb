class CtSessionSchedule < ActiveRecord::Base
	belongs_to :playing_area
	belongs_to :ct_session
	has_many :ct_reservations, :dependent => :destroy
  	validates_presence_of :ct_session_id, :session_start_date, :session_end_date
	
	def validate
    errors.add(:session_end_date, "should be greater than Session Start Date" ) if session_end_date <= session_start_date		
    errors.add(:monday_end_time, "should be greater than start time" ) if meet_monday && monday_end_time <= monday_start_time
    errors.add(:tuesday_end_time, "should be greater than start time" ) if meet_tuesday && tuesday_end_time <= tuesday_start_time
    errors.add(:wednesday_end_time, "should be greater than start time" ) if meet_wednesday && wednesday_end_time <= wednesday_start_time
    errors.add(:thursday_end_time, "should be greater than start time" ) if meet_thursday && thursday_end_time <= thursday_start_time
    errors.add(:friday_end_time, "should be greater than start time" ) if meet_friday && friday_end_time <= friday_start_time
    errors.add(:saturday_end_time, "should be greater than start time" ) if meet_saturday && saturday_end_time <= saturday_start_time
    errors.add(:sunday_end_time, "should be greater than start time" ) if meet_sunday && sunday_end_time <= sunday_start_time
	end
end
