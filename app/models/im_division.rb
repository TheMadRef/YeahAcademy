class ImDivision < ActiveRecord::Base
  has_many :im_teams, :order => "team_number", :dependent => :destroy
  has_many :im_free_agents, :dependent => :destroy
  belongs_to :im_league
  belongs_to :im_day_of_play

  validates_presence_of :division_name, :im_league_id, :end_time, :start_time
  validates_numericality_of :number_of_teams, :only_integer => true, :allow_nil => false
  def validate
    # id is nil if new division, when editing we want to make sure we are not validating division name against it self.
    if !im_league_id.nil?
      if id.nil?
        conditions = ["im_leagues.im_sport_id = ? AND im_divisions.division_name = ?", im_league.im_sport_id, division_name]
      else
        conditions = ["im_leagues.im_sport_id = ? AND im_divisions.division_name = ? AND im_divisions.id <> ?", im_league.im_sport_id, division_name, id]
      end 
      # Using inner join to figure out if there are duplicate division name in sport
      division_name_check = ImDivision.find(:first, 
              :joins => " inner join im_leagues ON im_league_id = im_leagues.id", 
              :conditions => conditions)             
      if not division_name_check.nil?
        errors.add(:division_name, "duplicate division name in sport")
      end
    end
    errors.add(:number_of_teams, "should be greater than one" ) if number_of_teams.nil? || number_of_teams < 2
    errors.add(:end_time, "should be greater than Start Time" ) if end_time.nil? || start_time.nil? || end_time <= start_time
    
    # Need validation in case number of teams is dropped under the existing number of teams, or there is a team number with a higher number than the number of teams allowed
    if !id.nil?
      if !ImTeam.maximum('team_number', :conditions => ["im_division_id = ? AND default_team = ?", id, false]).nil?
        team_max = ImTeam.maximum('team_number', :conditions => ["im_division_id = ? AND default_team = ?", id, false])
        errors.add(:number_of_teams, "can not be lower than existing team number") if number_of_teams.nil? || number_of_teams < team_max
      end
    end      
  end

  # Function to return array of available team numbers in division.
  # If new team, team_number must be 0
  def self.available_team_numbers_in_division(division_id, team_id)
    team_counter = 1
    team_number_list = []
    find(division_id).number_of_teams.times do
      if ImTeam.is_team_number_available(division_id, team_counter, team_id)
        team_number_list << ["#{team_counter}", team_counter]
      end
      team_counter += 1
    end
    return team_number_list
  end

  def self.available_jersey_colors_in_division(division_id, team_id)
    jersey_color_list = []
    
    for color in ImColor.find(:all, :order => "color_name ASC") do
      if ImTeam.is_jersey_color_available(division_id, color, team_id) || $g_allow_multiple_colors
        jersey_color_list << ["#{color.color_name}", color.id]
      end
    end
    return jersey_color_list
  end

  def self.is_division_full(division_id)
    division_count = ImTeam.number_of_teams_in_division(division_id)
    if division_count.nil? || division_count < ImDivision.find(division_id).number_of_teams
      return false
    else
      return true
    end
  end 

  def self.does_league_have_divisions(league_id)
    if count(["im_league_id = ?", league_id]) == 0
      return false
    else
      return true
    end
  end

	def self.division_team_order(id)
		division = find(id)
		if division.manual_sort
			return "place ASC"
		else
			if !division.im_league.im_sport.sort_heading_1.nil?
				sort_order = ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", division.im_league.im_sport.sort_heading_1]).column_name
				if !division.im_league.im_sport.sorting_1
					sort_order = sort_order + " ASC"
				else
					sort_order = sort_order + " DESC"
				end
			end
			if !division.im_league.im_sport.sort_heading_2.nil?
				sort_order = sort_order + ", " + ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", division.im_league.im_sport.sort_heading_2]).column_name
				if !division.im_league.im_sport.sorting_2
					sort_order = sort_order + " ASC"
				else
					sort_order = sort_order + " DESC"
				end
			end
			if !division.im_league.im_sport.sort_heading_3.nil?
				sort_order = sort_order + ", " + ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", division.im_league.im_sport.sort_heading_3]).column_name
				if !division.im_league.im_sport.sorting_3
					sort_order = sort_order + " ASC"
				else
					sort_order = sort_order + " DESC"
				end
			end
			return sort_order + ", team_number ASC"
		end
	end		
end
