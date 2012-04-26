class ImLeague < ActiveRecord::Base
  has_many :im_divisions, :order => "division_name", :dependent => :destroy
  has_many :im_teams, :order => "team_number", :dependent => :destroy
  has_many :im_free_agents, :dependent => :destroy
  has_many :rt_employee_title_league_relationships, :dependent => :destroy
  has_many :im_games, :dependent => :destroy
  has_many :im_brackets, :dependent => :destroy
  belongs_to :im_sport
  belongs_to :im_league, :foreign_key => "parent_id"
  
  validates_presence_of :league_name, :im_sport_id
  validates_numericality_of :max_allowed, :only_integer => true, :allow_nil => false
  validates_uniqueness_of :league_name, :scope => [:im_sport_id, :parent_id], :case_sensitive => false
  def validate
    # only validate max allowed if they typed something in
    if not max_allowed.nil?    
      errors.add(:max_allowed, "should be zero or greater" ) if max_allowed < 0
      # if editing league, need to make sure we don't cut the number of teams too low
      if !id.nil?
        max_number_of_teams = ImTeam.maximum('team_number', :conditions => ["im_league_id = ?", id])
        errors.add(:max_allowed, "can not be lower than existing team number") if !max_number_of_teams.nil? && max_allowed < max_number_of_teams
      end      
    end
    if not parent_id.nil?    
      errors.add(:parent_id, "should be zero or greater" ) if parent_id < 0
    else
      parent_id = 0
    end
  end  
  
  def self.leagues_for_sport(sport_id)
    im_league = find(:all, :conditions => ["im_sport_id = ?", sport_id])
    options = []
    for league in im_league do
      league_name = ""
      if not league.im_league.nil?
        league_name = league.im_league.league_name + " : "
      end
      league_name += league.league_name
      options << [league_name, league.id]
    end
    return options
  end

  def self.is_league_full(league_id)
    league_count = ImTeam.number_of_teams_in_league(league_id)
    if league_count < find(league_id).max_allowed
      return false
    else
      return true
    end
  end 
  
  def self.sorted_league_array(sport_id, division)
    array = []
    if sport_id == 0
      leagues_for_array = find(:all, :conditions => ["parent_id = ? OR parent_id IS NULL", 0], :order => "im_sport_id ASC, league_name ASC")
    else
      leagues_for_array = find(:all, :conditions => ["im_sport_id = ? AND (parent_id = ? OR parent_id IS NULL)", sport_id, 0], :order => "league_name ASC")
    end
    for league in leagues_for_array
      if division
        divisions_for_array = ImDivision.find(:all, :conditions => ["im_league_id = ?", league.id], :order => "division_name ASC")
        if !divisions_for_array.nil?
          for division in divisions_for_array
            array << division.id
          end
        end
      else
        array << league.id
      end
      sub_leagues_for_array = find(:all, :conditions => ["parent_id = ?", league.id], :order => "im_sport_id ASC, league_name ASC")
      if !sub_leagues_for_array.nil?
        for sub_league in sub_leagues_for_array
          if division
            divisions_for_array = ImDivision.find(:all, :conditions => ["im_league_id = ?", sub_league.id], :order => "division_name ASC")
            if !divisions_for_array.nil?
              for division in divisions_for_array
                array << division.id
              end
            end
          else
            array << sub_league.id
          end      
        end
      end
    end
    return array
  end

  def self.sorted_team_array(sport_id, unapproved_teams)
    array = []
    if sport_id == 0
      leagues_for_array = find(:all, :conditions => ["parent_id = ?", 0], :order => "im_sport_id ASC, league_name ASC")
    else
      leagues_for_array = find(:all, :conditions => ["im_sport_id = ? AND parent_id = ?", sport_id, 0], :order => "league_name ASC")
    end
    for league in leagues_for_array
      if unapproved_teams 
        teams_for_array = ImTeam.find(:all, :conditions => ["im_league_id = ? AND approved = ? AND default_team = ?", league.id, false, false], :order => "team_number")
      else
        teams_for_array = ImTeam.find(:all, :conditions => ["im_league_id = ? AND default_team = ?", league.id, false], :order => "team_number")
      end
      if !teams_for_array.nil?
        for team in teams_for_array do
          array << team.id
        end
      end
      divisions_for_array = ImDivision.find(:all, :conditions => ["im_league_id = ?", league.id], :order => "division_name ASC")
      if !divisions_for_array.nil?
        for division in divisions_for_array
          if unapproved_teams 
            teams_for_array = ImTeam.find(:all, :conditions => ["im_division_id = ? AND approved = ? AND default_team = ?", division.id, false, false], :order => "team_number")
          else
            teams_for_array = ImTeam.find(:all, :conditions => ["im_division_id = ? AND default_team = ?", division.id, false], :order => "team_number")
          end
          if !teams_for_array.nil?
            for team in teams_for_array do
              array << team.id
            end
          end
        end
      end
      sub_leagues_for_array = find(:all, :conditions => ["parent_id = ?", league.id], :order => "im_sport_id ASC, league_name ASC")
      if !sub_leagues_for_array.nil?
        for sub_league in sub_leagues_for_array
          if unapproved_teams
            teams_for_array = ImTeam.find(:all, :conditions => ["im_league_id = ? AND approved = ? AND default_team = ?", sub_league.id, false, false], :order => "team_number")
          else
            teams_for_array = ImTeam.find(:all, :conditions => ["im_league_id = ? AND default_team = ?", sub_league.id, false], :order => "team_number")
          end
          if !teams_for_array.nil?
            for team in teams_for_array do
              array << team.id
            end
          end
          divisions_for_array = ImDivision.find(:all, :conditions => ["im_league_id = ?", sub_league.id], :order => "division_name ASC")
          if !divisions_for_array.nil?
            for division in divisions_for_array
              if unapproved_teams
                teams_for_array = ImTeam.find(:all, :conditions => ["im_division_id = ? AND approved = ? AND default_team = ?", division.id, false, false], :order => "team_number")  
              else
                teams_for_array = ImTeam.find(:all, :conditions => ["im_division_id = ? AND default_team = ?", division.id, false], :order => "team_number")
              end
              if !teams_for_array.nil?
                for team in teams_for_array do
                  array << team.id
                end
              end
            end
          end
        end
      end
    end
    return array
  end
end
