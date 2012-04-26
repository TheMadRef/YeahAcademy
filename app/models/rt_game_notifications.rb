class RtGameNotifications < ActionMailer::Base
  def delete_game(participant_id, game_id, game_date, game_time, facility)
    @subject    = 'RefTrack Online Notification: Game Cancellation'
    participant = Participant.find_by_id(participant_id)
    @body["participant"] = participant.first_name
    @body["game_number"] = game_id
    @body["game_date"] = game_date
    @body["game_time"] = game_time
    @body["facility"] = facility
    @recipients = participant.email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}
  end
  
  def remove_from_game(participant_id, rt_employee_schedule_id)
    @subject    = 'RefTrack Online Notification: You have been removed from a game'
    participant = Participant.find_by_id(participant_id)
    employee_schedule = RtEmployeeSchedule.find_by_id(rt_employee_schedule_id)
    @body["participant"] = participant.first_name
    @body["game_number"] = employee_schedule.im_game_id
    @body["game_date"] = employee_schedule.im_game.game_time
    @body["game_time"] = employee_schedule.im_game.start_time
    @body["facility"] = employee_schedule.im_game.playing_area.facility.facility_name
    @body["employee_title"] = employee_schedule.rt_employee_title.employee_title
    @recipients = participant.email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}  	
	end
	
  def new_game_notification(participant_id)
    @subject    = 'RefTrack Online Notification: You have new game assignments'
    participant = Participant.find_by_id(participant_id)
    @body["participant"] = participant.first_name
    @recipients = participant.email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}  	
	end
	
	def decline_game(participant_id, im_game_id)
    @subject    = 'RefTrack Online Notification: A game has been declined'
    participant = Participant.find_by_id(participant_id)
    im_game = ImGame.find_by_id(im_game_id)
    @body["participant"] = participant.first_name + " " + participant.last_name
    @body["game_number"] = im_game_id
    @body["game_date"] = im_game.game_time
    @body["game_time"] = im_game.start_time
    @body["facility"] = im_game.playing_area.facility.facility_name
    @recipients = RtSetting.find(1).system_admin_email
    @from       = 'RefTrack Online Automated Email <do-not-reply@facilitrax.com>'
    @sent_on    = Time.now
    @headers    = {}  	
	end
end
