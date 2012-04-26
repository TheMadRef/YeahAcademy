class CtReservation < ActiveRecord::Base
  has_one :facility_event, :dependent => :destroy
  has_many :participant_events, :dependent => :destroy
  belongs_to :ct_session_schedule
  belongs_to :playing_area
  after_create :add_facility_event

  validates_presence_of :session_date, :start_time, :end_time, :ct_session_schedule_id
	validates_uniqueness_of :ct_session_schedule_id, :scope => [:session_date]

	before_destroy :email_participants_on_cancellation

  attr_accessor :allow_conflict
  
	def validate
    if !playing_area.nil?
      ct_session_id = CtReservation.is_time_slot_available(session_date, start_time, end_time, playing_area_id, id)
      if !ct_session_id.nil? && !allow_conflict
        errors.add(:session_date, " conflicts at this date/time slot/playing area with session #{ct_session_id}")
      end
	  im_game_id = ImGame.is_time_slot_available(session_date, start_time, end_time, playing_area_id, 0)
      if !im_game_id.nil? && !allow_conflict
        errors.add(:session_date, " conflicts at this date/time slot/playing area with game number #{im_game_id}")
      end
    end		
	end
	
  def self.is_time_slot_available(date, start_time, end_time, playing_area_id, id)
    parent_id = PlayingArea.find_by_id(playing_area_id.to_i).parent_id
    if id.nil?
    	id = 0
    end
    if parent_id > 0
      parent_record = find(:first, :conditions => ["session_date = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?)) AND (playing_area_id = ? OR playing_area_id = ?) AND id != ?", date, start_time, end_time, start_time, end_time, start_time, end_time, playing_area_id, parent_id, id])
      if !parent_record.nil?
        return parent_record.ct_session_schedule.ct_session_id
      end
    else
      parent_record = find(:first, :conditions => ["session_date = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?)) AND playing_area_id = ? AND id != ?", date, start_time, end_time, start_time, end_time, start_time, end_time, playing_area_id, id])
      if parent_record.nil?
        playing_areas = PlayingArea.find(:all, :conditions => ["parent_id = ?", playing_area_id])
        for playing_area in playing_areas
          child_record = find(:first, :conditions => ["session_date = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?)) AND playing_area_id = ? AND id != ?", date, start_time, end_time, start_time, end_time, start_time, end_time, playing_area.id, id])
          if !child_record.nil?
            return child_record.ct_session_schedule.ct_session_id
          end
        end
      else
        return parent_record.ct_session_schedule.ct_session_id
      end
    end
    return nil
  end	

	protected
		def add_facility_event
			facility_event = FacilityEvent.new
			facility_event.ct_reservation_id = self.id		
			facility_event.save		
		end

		def email_participants_on_cancellation
			participants_in_session = self.participant_events.find(:all)
			for participant in participants_in_session
				email = CtSessionNotifications.create_cancel_session(participant.participant_id, ct_session_id, session_date, start_time, playing_area.facility.facility_name)
			  begin
			    CtSessionNotifications.deliver(email)
			  rescue
			  	
			  end
		  end
		end		
end
