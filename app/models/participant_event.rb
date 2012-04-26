class ParticipantEvent < ActiveRecord::Base
	belongs_to :participant
	belongs_to :ct_reservation
	
	validates_presence_of :participant_id, :ct_reservation_id
	validates_uniqueness_of :participant_id, :scope => [:ct_reservation_id]
	
	def validate
		errors.add(:participant_id, " already has another class scheduled that conflicts with this class") if !ParticipantEvent.is_time_slot_available(participant_id, ct_reservation.session_date, ct_reservation.start_time, ct_reservation.end_time, id)
	end
	
  def self.is_time_slot_available(participant_id, date, start_time, end_time, id)
  	if id.nil?
  		id = 0
  	end
    return find(:first, :joins => " INNER JOIN ct_reservations ON ct_reservations.id = participant_events.ct_reservation_id", :conditions => ["participant_events.participant_id = ? AND ct_reservations.session_date = ? AND ((ct_reservations.start_time <= ? AND ct_reservations.end_time >= ?) OR (ct_reservations.start_time >= ? AND ct_reservations.start_time < ?) OR (ct_reservations.end_time > ? AND ct_reservations.end_time <= ?)) AND participant_events.id != ?", participant_id, date, start_time, end_time, start_time, end_time, start_time, end_time, id]).nil?  
  end
end
