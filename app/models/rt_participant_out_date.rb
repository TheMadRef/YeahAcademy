class RtParticipantOutDate < ActiveRecord::Base
  belongs_to :participant
  belongs_to :rt_participant_out_date, :foreign_key => "parent_id"
  has_one :rt_employee_calendar, :dependent => :destroy
  
  # Virtual attribute for the end date, kind of block
  attr_accessor :multiple_block_type, :block_type, :block_0, :block_1, :block_2, :block_3, :block_4, :block_5, :block_6 

  validates_presence_of :participant_id, :out_date, :start_time, :end_time

  def validate
    if block_type == "1"
      errors.add(:end_date, "should be greater than the Start Date" ) if end_date.nil? || end_date.to_date < out_date
    end
    errors.add(:end_time, "should be greater than the Start Time" ) if end_time.nil? || end_time < start_time
    if not parent_id.nil?    
      errors.add(:parent_id, "should be zero or greater" ) if parent_id < 0
    end
    errors.add(:out_date, "you have a game already scheduled this date/time combination") if !RtEmployeeSchedule.is_time_slot_available(participant_id, out_date, start_time, end_time, 0)
  end  

  def self.is_time_slot_available(participant_id, date, start_time, end_time)
    return find(:first, :conditions => ["participant_id = ? AND out_date = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?))", participant_id, date, start_time, end_time, start_time, end_time, start_time, end_time]).nil?  
  end

end
