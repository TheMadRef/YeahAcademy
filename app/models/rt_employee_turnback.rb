class RtEmployeeTurnback < ActiveRecord::Base
  belongs_to :participant
  belongs_to :im_game
	has_one :rt_employee_calendar, :dependent => :destroy

  validates_presence_of :participant_id, :im_game_id
  
  def self.is_time_slot_available(participant_id, date, start_time, end_time)
    return find(:first, :joins => " INNER JOIN im_games ON im_games.id = rt_employee_turnbacks.im_game_id", :conditions => ["rt_employee_turnbacks.participant_id = ? AND im_games.game_time = ? AND ((im_games.start_time <= ? AND im_games.end_time >= ?) OR (im_games.start_time >= ? AND im_games.start_time < ?) OR (im_games.end_time > ? AND im_games.end_time <= ?))", participant_id, date, start_time, end_time, start_time, end_time, start_time, end_time]).nil?  
  end
  
end
