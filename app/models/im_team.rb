class ImTeam < ActiveRecord::Base
  has_many :im_rosters, :dependent => :destroy
  has_many :im_free_agent_invitations, :dependent => :destroy
  has_many :rt_participant_team_relationships, :dependent => :destroy
  has_many :rt_participant_team_blocks, :dependent => :destroy
  has_many :im_games, :foreign_key => "home_team_id"
  has_many :im_games, :foreign_key => "away_team_id"
  has_one :line_item
  belongs_to :im_division
  belongs_to :im_league
  belongs_to :im_color
  belongs_to :playing_area
  
  # Virtual attribute for the unencrypted password
  attr_accessor :basic_password

  validates_presence_of :team_name, :if => :verify_team_name?
  validates_length_of :team_name, :within => 2..50, :too_long => "is over the limit of 50 character", :too_short => "needs to be at least 2 characters long", :if => :verify_team_name?
  validates_inclusion_of :approved, :in => [true, false]
  validates_presence_of :basic_password, :if => :password_required?
  validates_length_of :basic_password, :within => 6..16, :too_long => "the team password is longer than 16 characters", :too_short => "the team password should be at least 6 characters long", :if => :password_required?
  validates_presence_of :im_color_id, :if => :validate_color
  validates_uniqueness_of :im_color_id, :scope => [:im_division_id], :if => :require_unique_color

  before_save :encrypt_basic_password

  def validate
    # id is nil if new team, when editing we want to make sure we are not validating team name against it self.
    # Using inner join to figure out if there are duplicate team name in sport
    if !default_team
    	if !im_division_id.nil?
	      if id.nil?
	        team_name_check = ImTeam.find(:first, 
	                :joins => " inner join (im_divisions INNER JOIN im_leagues ON im_divisions.im_league_id = im_leagues.id) ON im_teams.im_division_id = im_divisions.id", 
	                :conditions => ["im_leagues.im_sport_id = ? AND im_teams.team_name = ?", im_division.im_league.im_sport_id, team_name])             
	      else
	        team_name_check = ImTeam.find(:first, 
	                :joins => " inner join (im_divisions INNER JOIN im_leagues ON im_divisions.im_league_id = im_leagues.id) ON im_teams.im_division_id = im_divisions.id", 
	                :conditions => ["im_leagues.im_sport_id = ? AND im_teams.team_name = ? AND im_teams.id <> ?", im_division.im_league.im_sport_id, team_name, id])
	      end 
	    else
	      if id.nil?
	        team_name_check = ImTeam.find(:first, 
	                :joins => " inner join im_leagues ON im_teams.im_league_id = im_leagues.id",
	                :conditions => ["im_leagues.im_sport_id = ? AND im_teams.team_name = ?", im_league.im_sport_id, team_name])                 
	      else
	        team_name_check = ImTeam.find(:first, 
	                :joins => " inner join im_leagues ON im_teams.im_league_id = im_leagues.id",
	                :conditions => ["im_leagues.im_sport_id = ? AND im_teams.team_name = ? AND im_teams.id <> ?", im_league.im_sport_id, team_name, id])
	      end 
	    end
  	  if not team_name_check.nil?
    	  errors.add(:team_name, "already exists in this sport")
    	end
		end
		
    #need to verify validity of team_number
    if !im_division_id.nil?
      if team_number.nil?
        errors.add(:team_number, "Can not be blank")      
      end
      if id.nil?
        team_number_check = ImTeam.find(:first, :conditions => ["im_division_id = ? AND team_number = ?", im_division_id, team_number])             
      else
        team_number_check = ImTeam.find(:first, :conditions => ["im_division_id = ? AND team_number = ? AND id <> ?", im_division_id, team_number, id])             
      end 
    else
      if id.nil?
        team_number_check = ImTeam.find(:first, :conditions => ["im_league_id = ? AND team_number = ?", im_league_id, team_number])             
      else
        team_number_check = ImTeam.find(:first, :conditions => ["im_league_id = ? AND team_number = ? AND id <> ?", im_league_id, team_number, id])             
      end 
    end
    if not team_number_check.nil?
      errors.add(:team_number, "Team number already taken")
    end
    
    #need to verify that terms and conditions were accepted, if accesible
    if $g_team_terms_and_conditions
      errors.add(:terms_and_conditions, "must be accepted") if !terms_and_conditions
    end    

    #Can't approve team unless they meet the roster minimum or minimum is 1 which means new captain will meet minimum
    if approved?
      if !im_division_id.nil?
        roster_minimum = im_division.im_league.im_sport.roster_minimum
        roster_price = im_division.im_league.im_sport.roster_price
      else
        roster_minimum = im_league.im_sport.roster_minimum
        roster_price = im_league.im_sport.roster_price
      end
      if roster_price > 0 
        errors.add(:approved, " invalid when paid team members under roster minimum") if ((ImRoster.paid_roster_count_for_team(id) < roster_minimum) && (roster_minimum > 0))
      else
        errors.add(:approved, " invalid when team under roster minimum") if ((ImRoster.roster_count_for_team(id) < roster_minimum) && (roster_minimum > 0))
      end
    end

    #Can't approve an un-paid team
    if !paid && approved
      errors.add(:approved, "can not approve un-paid team")
    end
  end

  def self.is_team_number_available(division_id, team_number, team_id)
    team_for_team_number = find(:first, :conditions => ["im_division_id = ? AND team_number = ? AND default_team = ?", division_id, team_number, false])
    if team_for_team_number.nil?
      return true
    elsif team_for_team_number.id == team_id
      return true
    else
      return false
    end
  end

  def self.is_jersey_color_available(division_id, color_id, team_id)
    team_for_jersey_color = find(:first, :conditions => ["im_division_id = ? AND im_color_id = ?", division_id, color_id])
    if team_for_jersey_color.nil?
      return true
    elsif team_for_jersey_color.id == team_id
      return true
    else
      return false
    end
  end
  
  def self.number_of_teams_in_division(division_id)
    count(["im_division_id = ? AND default_team = ?", division_id, false])
  end
  
  def self.does_league_have_teams(league_id)
    if count(["im_league_id = ?", league_id]) == 0
      return false
    else
      return true
    end
  end  
  
  def self.number_of_teams_in_league(league_id)
    count(["im_league_id = ?", league_id])
  end
  
  def validate_color
    if !im_division_id.nil? && !default_team && im_division.im_league.im_sport.jersey_color
      return true
    else
      return false    
    end
  end

  def require_unique_color
    if !im_division_id.nil? && !default_team && !$g_allow_multiple_colors && im_division.im_league.im_sport.jersey_color
      return true
    else
      return false
    end  
  end
  
  def self.teams_for_sport(sport_id)
    return find(:all, :order => "team_name", :select => "im_teams.id, im_teams.team_name", :joins => "INNER JOIN (im_leagues LEFT JOIN im_divisions ON im_leagues.id = im_divisions.im_league_id) ON (im_teams.im_division_id = im_divisions.id OR im_teams.im_league_id = im_leagues.id)", :conditions => ["im_leagues.im_sport_id = ? AND default_team = ?", sport_id, false])
  end

  def self.find_by_basic_password(basic_password)
    return nil if basic_password.nil? || basic_password == ""
    find_all_by_password(encrypt_password(basic_password))
  end
  
  def self.encrypt_password(basic_password)
    # hard code salt for now
    Digest::SHA1.hexdigest("--teamsnowneedpassword--#{basic_password}--")
  end

  protected
    # before filter 
    def encrypt_basic_password
      return if basic_password.blank?
      self.password = self.class.encrypt_password(basic_password)
    end

    def password_required?
      password.blank? || !basic_password.blank?
    end    

		def verify_team_name?
			return !default_team
		end
end

