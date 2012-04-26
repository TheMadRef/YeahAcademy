class ImGame < ActiveRecord::Base
  has_one :facility_event, :dependent => :destroy
  has_one :im_game_of_the_day
  has_many :rt_employee_schedules, :dependent => :destroy
  has_many :rt_employee_turnbacks, :dependent => :destroy
  belongs_to :home_team, :class_name => "ImTeam", :foreign_key => "home_team_id"
  belongs_to :away_team, :class_name => "ImTeam", :foreign_key => "away_team_id"
  belongs_to :im_league
  belongs_to :im_bracket
  belongs_to :playing_area
  belongs_to :im_game, :foreign_key => "parent_id"
  belongs_to :reservation
  
  # Virtual attribute for allowing conflicts/creating block of games
  attr_accessor :allow_conflict
  attr_accessor :hour_length
  attr_accessor :minute_length
  attr_accessor :number_of_games

  validates_presence_of :game_time, :start_time, :end_time
  validates_presence_of :im_league_id, :if => :im_league_required?, :message => "Must specify either the home team or the league for this game."
  validates_presence_of :home_team_id, :if => :home_team_required?, :message => "Must specify either the home team or the league for this game."

  def validate
    #validating parent_id
    if not parent_id.nil?    
      errors.add(:parent_id, "should be zero or greater" ) if parent_id < 0
    else
      parent_id = 0
    end
    if !playing_area.nil?
      game_number = ImGame.is_time_slot_available(game_time, start_time, end_time, playing_area_id, id)
      if !game_number.nil? && !allow_conflict
        errors.add(:game_time, " conflicts at this date/time slot/playing area with game  #{game_number}")
      end
      ct_session_id = CtReservation.is_time_slot_available(game_time, start_time, end_time, playing_area_id, 0)
      if !ct_session_id.nil? && !allow_conflict
        errors.add(:session_date, " conflicts at this date/time slot/playing area with session #{ct_session_id}")
      end
    end
  end    

  def self.is_time_slot_available(date, start_time, end_time, playing_area_id, id)
    parent_id = PlayingArea.find_by_id(playing_area_id.to_i).parent_id
    if id.nil?
    	id = 0
    end
    if parent_id > 0
      parent_record = find(:first, :conditions => ["game_time = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?)) AND (playing_area_id = ? OR playing_area_id = ?) AND id != ?", date, start_time, end_time, start_time, end_time, start_time, end_time, playing_area_id, parent_id, id])
      if !parent_record.nil?
        return parent_record.id
      end
    else
      parent_record = find(:first, :conditions => ["game_time = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?)) AND playing_area_id = ? AND id != ?", date, start_time, end_time, start_time, end_time, start_time, end_time, playing_area_id, id])
      if parent_record.nil?
        playing_areas = PlayingArea.find(:all, :conditions => ["parent_id = ?", playing_area_id])
        for playing_area in playing_areas
          child_record = find(:first, :conditions => ["game_time = ? AND ((start_time <= ? AND end_time >= ?) OR (start_time >= ? AND start_time < ?) OR (end_time > ? AND end_time <= ?)) AND playing_area_id = ? AND id != ?", date, start_time, end_time, start_time, end_time, start_time, end_time, playing_area.id, id])
          if !child_record.nil?
            return child_record.id
          end
        end
      else
        return parent_record.id
      end
    end
    return nil
  end

  def im_league_required?
    return home_team_id.nil?
  end

  def home_team_required?
    return im_league_id.nil?
  end

	def self.games_for_team(team_id)
		return ImGame.find(:all, :order => "im_games.game_time, im_games.start_time, im_games.playing_area_id", :conditions => ["home_team_id = ? OR away_team_id = ?", team_id, team_id])
	end

	def self.games_for_division(division_id)
		return ImGame.find(:all, :order => "im_games.game_time, im_games.start_time, im_games.playing_area_id", :conditions => ["im_division_id = ?", division_id], :select => "DISTINCT im_games.*", :joins => "INNER JOIN im_teams ON (im_teams.id = im_games.home_team_id OR im_teams.id = im_games.away_team_id) INNER JOIN im_divisions ON im_teams.im_division_id = im_divisions.id")
	end

  def self.sorted_game_array(sport_id, start_date, end_date, participant_id, team_id, playing_area_id, admin)
    array = []
    if participant_id.blank?
      if team_id.blank?
        if sport_id.blank?
        	if playing_area_id.blank?
          	im_games_for_array = find(:all, :conditions => ["game_time >= ? AND game_time <= ?", start_date, end_date], :order => "game_time, playing_area_id, start_time")
          else
          	im_games_for_array = find(:all, :conditions => ["game_time >= ? AND game_time <= ? AND playing_area_id = ?", start_date, end_date, playing_area_id], :order => "game_time, start_time")
					end          		
        else
        	if playing_area_id.blank?
        	  im_games_for_array = find(:all, :joins => " LEFT JOIN (im_teams RIGHT JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_league_id = im_leagues.id OR im_teams.im_division_id = im_divisions.id)) ON (im_games.im_league_id = im_leagues.id OR im_games.home_team_id = im_teams.id)", :select => "DISTINCT im_games.*", :conditions => ["im_leagues.im_sport_id = ? AND im_games.game_time >= ? AND im_games.game_time <+ ?", sport_id, start_date, end_date], :order => "im_games.game_time, im_games.start_time, im_games.playing_area_id")
					else
        	  im_games_for_array = find(:all, :joins => " LEFT JOIN (im_teams RIGHT JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_league_id = im_leagues.id OR im_teams.im_division_id = im_divisions.id)) ON (im_games.im_league_id = im_leagues.id OR im_games.home_team_id = im_teams.id)", :select => "DISTINCT im_games.*", :conditions => ["im_leagues.im_sport_id = ? AND im_games.game_time >= ? AND im_games.game_time <+ ? AND im_games.playing_area_id = ?", sport_id, start_date, end_date, playing_area_id], :order => "im_games.game_time, im_games.start_time")
					end	
        end
      else
      	if playing_area_id.blank?
	    	  im_games_for_array = find(:all, :conditions => ["im_games.game_time >= ? AND im_games.game_time <= ? AND (home_team_id = ? OR away_team_id = ?)", start_date, end_date, team_id, team_id], :order => "game_time, playing_area_id, start_time")
				else
	    	  im_games_for_array = find(:all, :conditions => ["im_games.game_time >= ? AND im_games.game_time <= ? AND (home_team_id = ? OR away_team_id = ?) AND playing_area_id = ?", start_date, end_date, team_id, team_id, playing_area_id], :order => "game_time, start_time")
        end
      end      
    elsif admin
      if team_id.blank?
        if sport_id.blank?
          if playing_area_id.blank?
            im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["rt_employee_schedules.participant_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ?", participant_id, start_date, end_date], :select => "DISTINCT im_games.*", :order => "im_games.game_time, im_games.playing_area_id, im_games.start_time")
          else
            im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["rt_employee_schedules.participant_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ? AND im_games.playing_area_id = ?", participant_id, start_date, end_date, playing_area_id], :select => "DISTINCT im_games.*", :order => "im_games.game_time, im_games.start_time")
          end
        else
      		if playing_area_id.blank?
            im_games_for_array = find(:all, :joins => " LEFT JOIN (im_teams RIGHT JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_league_id = im_leagues.id OR im_teams.im_division_id = im_divisions.id)) ON (im_games.im_league_id = im_leagues.id OR im_games.home_team_id = im_teams.id) INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :select => "DISTINCT im_games.*", :conditions => ["im_leagues.im_sport_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ? AND rt_employee_schedules.participant_id = ?", sport_id, start_date, end_date, participant_id], :order => "im_games.game_time, im_games.playing_area_id, im_games.start_time")
          else
            im_games_for_array = find(:all, :joins => " LEFT JOIN (im_teams RIGHT JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_league_id = im_leagues.id OR im_teams.im_division_id = im_divisions.id)) ON (im_games.im_league_id = im_leagues.id OR im_games.home_team_id = im_teams.id) INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :select => "DISTINCT im_games.*", :conditions => ["im_leagues.im_sport_id = ?  AND im_games.game_time >= ? AND im_games.game_time <= ? AND im_games.playing_area_id = ? AND rt_employee_schedules.participant_id = ?", sport_id, start_date, end_date, playing_area_id, participant_id], :order => "im_games.game_time, im_games.start_time")
          end
        end
      else
        if playing_area_id.blank?
          im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["(im_games.home_team_id = ? OR im_games.away_team_id = ?) AND im_games.game_time >= ? AND im_games.game_time <= ? AND rt_employee_schedules.participant_id = ?", team_id, team_id, start_date, end_date, participant_id], :order => "game_time, playing_area_id, start_time", :select => "DISTINCT im_games.*")
        else
          im_games_for_array = find(:all, :joins => "  INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["(im_games.home_team_id = ? OR im_games.away_team_id = ?) AND im_games.game_time >= ? AND im_games.game_time <= ? AND im_games.playing_area_id = ? AND rt_employee_schedules.partipant_id = ?", team_id, team_id, start_date, end_date, playing_area_id, participant_id], :order => "game_time, start_time", :select => "DISTINCT im_games.*")
        end
      end          	
		else
      if team_id.blank?
        if sport_id.blank?
          if playing_area_id.blank?
            im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["rt_employee_schedules.participant_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ? AND rt_employee_schedules.status = ?", participant_id, start_date, end_date, 2], :select => "DISTINCT im_games.*", :order => "im_games.game_time, im_games.playing_area_id, im_games.start_time")
          else
            im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["rt_employee_schedules.participant_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ? AND im_games.playing_area_id = ? AND rt_employee_schedules.status = ?", participant_id, start_date, end_date, playing_area_id, 2], :select => "DISTINCT im_games.*", :order => "im_games.game_time, im_games.start_time")
          end
        else
      		if playing_area_id.blank?
            im_games_for_array = find(:all, :joins => " LEFT JOIN (im_teams RIGHT JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_league_id = im_leagues.id OR im_teams.im_division_id = im_divisions.id)) ON (im_games.im_league_id = im_leagues.id OR im_games.home_team_id = im_teams.id) INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :select => "DISTINCT im_games.*", :conditions => ["im_leagues.im_sport_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ? AND rt_employee_schedules.participant_id = ? AND rt_employee_schedules.status = ?", sport_id, start_date, end_date, participant_id, 2], :order => "im_games.game_time, im_games.playing_area_id, im_games.start_time")
          else
            im_games_for_array = find(:all, :joins => " LEFT JOIN (im_teams RIGHT JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_league_id = im_leagues.id OR im_teams.im_division_id = im_divisions.id)) ON (im_games.im_league_id = im_leagues.id OR im_games.home_team_id = im_teams.id) INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :select => "DISTINCT im_games.*", :conditions => ["im_leagues.im_sport_id = ?  AND im_games.game_time >= ? AND im_games.game_time <= ? AND im_games.playing_area_id = ? AND rt_employee_schedules.participant_id = ? AND rt_employee_schedules.status = ?", sport_id, start_date, end_date, playing_area_id, participant_id, 2], :order => "im_games.game_time, im_games.start_time")
          end
        end
      else
        if playing_area_id.blank?
          im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["(im_games.home_team_id = ? OR im_games.away_team_id = ?) AND im_games.game_time >= ? AND im_games.game_time <= ? AND rt_employee_schedules.participant_id = ? AND rt_employee_schedules.status = ?", team_id, team_id, start_date, end_date, participant_id, 2], :order => "game_time, playing_area_id, start_time", :select => "DISTINCT im_games.*")
        else
          im_games_for_array = find(:all, :joins => "  INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["(im_games.home_team_id = ? OR im_games.away_team_id = ?) AND im_games.game_time >= ? AND im_games.game_time <= ? AND im_games.playing_area_id = ? AND rt_employee_schedules.partipant_id = ? AND rt_employee_schedules.status = ?", team_id, team_id, start_date, end_date, playing_area_id, participant_id, 2], :order => "game_time, start_time", :select => "DISTINCT im_games.*")
        end
      end          	
    end
    if !im_games_for_array[0].nil?
      for game in im_games_for_array
        array << game.id
      end
    end
    return array
  end

  def self.upcoming_games_for_participant(participant_id)
    array = []
    im_games_for_array = find(:all, :joins => " INNER JOIN rt_employee_schedules ON im_games.id = rt_employee_schedules.im_game_id", :conditions => ["rt_employee_schedules.participant_id = ? AND im_games.game_time >= ? AND im_games.game_time <= ? AND rt_employee_schedules.status = ?", participant_id, Date.today, Date.today + 10, 2], :select => "DISTINCT im_games.*", :order => "im_games.game_time, im_games.playing_area_id, im_games.start_time")
    if !im_games_for_array[0].nil?
      for game in im_games_for_array
        array << game.id
      end
    end
    return array
  end
	protected
		def add_facility_event
			facility_event = FacilityEvent.new
			facility_event.im_game_id = self.id
			facility_event.save		
		end
end
