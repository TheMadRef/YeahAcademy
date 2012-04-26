class RtEmployeeSchedule < ActiveRecord::Base
  belongs_to :participant
  belongs_to :im_game
  belongs_to :rt_employee_title, :order => "sorting_order"
	has_one :rt_employee_calendar, :dependent => :destroy
	before_destroy :send_cancellation_email
	
  validates_presence_of :rt_employee_title_id, :im_game_id
  validates_uniqueness_of :rt_employee_title_id, :scope => :im_game_id, :message => "has already been added for this sport"

  def self.create_temp_employees(employee_title_id, im_game_id)
    temp_schedule = new
    temp_schedule.rt_employee_title_id = employee_title_id
    temp_schedule.im_game_id = im_game_id
    temp_schedule.save!   
  end

  def self.participants_for_game(id, end_time, allow_block_conflicts, allow_game_conflicts, allow_turnback_conflicts, show_all_employees)
    rt_employee_schedule = find(id)
    participant_array = []
    if show_all_employees
      participants = Participant.find(:all, :joins => " INNER JOIN (rt_participant_user_group_relationships INNER JOIN rt_user_groups ON rt_participant_user_group_relationships.rt_user_groups_id = rt_user_groups.id) ON rt_user_group_relationships.participant_id = partcipants.id", :conditions => ["rt_user_groups.rt_user_group_type_id = ?", 1], :select => "DISTINCT participants.id, participants.first_name, participants.mi, participants.last_name", :order => "participants.last_name, participants.first_name")  
      for participant in participants
        participant_array << [id, "#{participant.first_name} #{participant.mi} #{participant.last_name}"]
      end
    else    
      participants = rt_employee_schedule.rt_employee_title.rt_user_group.rt_participant_user_group_relationships.find(:all, :joins => " INNER JOIN participants ON rt_participant_user_group_relationships.participant_id = participants.id", :select => "participants.id, participants.first_name, participants.last_name, participants.mi", :order => "participants.last_name, participants.first_name")
      for participant in participants
        valid_participant = true
        #check against employee out dates
        if !allow_block_conflicts
          valid_participant = RtParticipantOutDate.is_time_slot_available(participant.id, rt_employee_schedule.im_game.game_time, rt_employee_schedule.im_game.start_time, end_time)
        end
        # check against other assignments
        if !allow_game_conflicts && valid_participant
          valid_participant = is_time_slot_available(participant.id, rt_employee_schedule.im_game.game_time, rt_employee_schedule.im_game.start_time, end_time, rt_employee_schedule.im_game.id)
        end
        # check against employee turn backs
        if !allow_turnback_conflicts && valid_participant
          valid_participant = RtEmployeeTurnback.is_time_slot_available(participant.id, rt_employee_schedule.im_game.game_time, rt_employee_schedule.im_game.start_time, end_time)
        end
        if valid_participant || rt_employee_schedule.participant_id == participant.id
          participant_array << [participant.id, "#{participant.first_name} #{participant.mi} #{participant.last_name}"]
        end
      end      
    end
    return participant_array
  end

  def self.is_time_slot_available(participant_id, date, start_time, end_time, game_id)
    return find(:first, :joins => " INNER JOIN im_games ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["im_games.id <> ? AND rt_employee_schedules.participant_id = ? AND im_games.game_time = ? AND ((im_games.start_time <= ? AND im_games.end_time >= ?) OR (im_games.start_time >= ? AND im_games.start_time < ?) OR (im_games.end_time > ? AND im_games.end_time <= ?))", game_id, participant_id, date, start_time, end_time, start_time, end_time, start_time, end_time]).nil?  
  end
  
  def send_cancellation_email
  	if !participant_id.nil?
	  	game = ImGame.find_by_id(im_game_id)
	    if game.game_time >= Date.today
	    	email = RtGameNotifications.create_delete_game(participant_id, im_game_id, game.game_time, game.start_time, game.playing_area.facility.facility_name)
		    begin
		    	RtGameNotifications.deliver(email)
		    rescue
		    	
		    end
	    end
		end
  end

  def self.games_for_participant_to_accept(participant_id)
    return find(:all, :joins => " INNER JOIN im_games ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["rt_employee_schedules.participant_id = ? AND rt_employee_schedules.status = ?", participant_id, 1], :select => "rt_employee_schedules.*", :order => "im_games.game_time, im_games.playing_area_id, im_games.start_time")
  end
end
