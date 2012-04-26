class ImRoster < ActiveRecord::Base
  belongs_to :im_team
  belongs_to :participant
  has_one :line_item

  validates_presence_of :participant_id, :message => "could not be found in participant database"
  validates_presence_of :im_team_id
  validates_uniqueness_of :participant_id, :scope => :im_team_id, :message => "is already on this roster"
  def validate
    # Validate eligibility    
    if !participant_id.nil? && $g_verify_im_eligibility
      errors.add(:participant_id, "not eligible") if !participant.im_active
    end

    #validate that team does not exceed roster limit
    if !im_team_id.nil?
      roster_count = ImRoster.roster_count_for_team(im_team_id)
      if !im_team.im_division_id.nil?
        if roster_count >= im_team.im_division.im_league.im_sport.roster_maximum
          errors.add(:im_team_id, "has reached roster maximum")
        end        
      else
        if roster_count >= im_team.im_league.im_sport.roster_maximum
          errors.add(:im_team_id, "has reached roster maximum")
        end
      end
    end
    if captain && !im_team_id.nil?
      # Validating against captain limits, first overall, then division, then league, then sport
      if ImRoster.count(:conditions => ["participant_id = ? AND im_team_id <> ? AND captain = ?", participant_id, im_team_id, true]) >= $g_overall_captain_limit
        errors.add(:participant_id, "already is captain for the maximum number of teams allowed")
      end
      if !im_team.im_division_id.nil?
        if ImRoster.count(:joins => "INNER JOIN im_teams on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_teams.im_division_id = ? AND captain = ?", participant_id, im_team_id, im_team.im_division_id, true]) >= $g_captain_limit_per_division
          errors.add(:participant_id, "already is captain for the maximum number of teams allowed per division")
        end
        league_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_divisions on im_teams.im_division_id = im_divisions.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_divisions.im_league_id = ? AND captain = ?", participant_id, im_team_id, im_team.im_division.im_league_id, true])
        sport_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN (im_divisions INNER JOIN im_leagues ON im_divisions.im_league_id = im_leagues.id) on im_teams.im_division_id = im_divisions.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ? AND captain = ?", participant_id, im_team_id, im_team.im_division.im_league.im_sport_id, true])
        sport_count += ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_leagues on im_teams.im_league_id = im_leagues.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ? AND captain = ?", participant_id, im_team_id, im_team.im_division.im_league.im_sport_id, true])
      else
        league_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_leagues on im_teams.im_league_id = im_leagues.id) on im_rosters.im_team_id = im_teams.id", :conditions =>  ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.id = ? AND captain = ?", participant_id, im_team_id, im_team.im_league_id, true])
        sport_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN (im_divisions INNER JOIN im_leagues ON im_divisions.im_league_id = im_leagues.id) on im_teams.im_division_id = im_divisions.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ? AND captain = ?", participant_id, im_team_id, im_team.im_league.im_sport_id, true])
        sport_count += ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_leagues on im_teams.im_league_id = im_leagues.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ? AND captain = ?", participant_id, im_team_id, im_team.im_league.im_sport_id, true])
      end
      if league_count >= $g_captain_limit_per_league
        errors.add(:participant_id, "already is captain for the maximum number of teams allowed per league")
      end
      if sport_count >= $g_captain_limit_per_sport
        errors.add(:participant_id, "already is captain for the maximum number of teams allowed per sport")
      end

      # now validating if the member has a captain card
      if $g_captain_cards
        errors.add(:participant_id, "must have a captain card") if ImCaptainCard.find(:first, :conditions=> ["participant_id = ?", participant_id]).nil?
      end
    end    

    # now validating against roster limits
    if !im_team_id.nil?
      if !im_team.im_division_id.nil?
        league_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_divisions on im_teams.im_division_id = im_divisions.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_divisions.im_league_id = ?", participant_id, im_team_id, im_team.im_division.im_league_id])
        sport_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN (im_divisions INNER JOIN im_leagues ON im_divisions.im_league_id = im_leagues.id) on im_teams.im_division_id = im_divisions.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ?", participant_id, im_team_id, im_team.im_division.im_league.im_sport_id])
        sport_count += ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_leagues on im_teams.im_league_id = im_leagues.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ?", participant_id, im_team_id, im_team.im_division.im_league.im_sport_id])
      else
        league_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_leagues on im_teams.im_league_id = im_leagues.id) on im_rosters.im_team_id = im_teams.id", :conditions =>  ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.id = ?", participant_id, im_team_id, im_team.im_league_id])
        sport_count = ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN (im_divisions INNER JOIN im_leagues ON im_divisions.im_league_id = im_leagues.id) on im_teams.im_division_id = im_divisions.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ?", participant_id, im_team_id, im_team.im_league.im_sport_id])
        sport_count += ImRoster.count(:joins => "INNER JOIN (im_teams INNER JOIN im_leagues on im_teams.im_league_id = im_leagues.id) on im_rosters.im_team_id = im_teams.id", :conditions => ["im_rosters.participant_id = ? AND im_rosters.im_team_id <> ? AND im_leagues.im_sport_id = ?", participant_id, im_team_id, im_team.im_league.im_sport_id])
      end
      if league_count >= $g_participant_roster_limit_per_league
        errors.add(:participant_id, "has already reached the limit for teams in this league")
      end
      if sport_count >= $g_participant_roster_limit_per_sport
        errors.add(:participant_id, "has already reached the limit for teams in this sport")
      end      
    end

    # now validating that the user has accepted the im terms and conditions
    if !participant_id.nil? && $g_master_im_terms_and_conditions
      errors.add(:participant_id, "must accept league play terms and conditions") if !participant.im_terms_and_conditions
    end
    
    # now validate that member accepted terms and conditions to join roster
    if !participant_id.nil?  && $g_roster_terms_and_conditions
      errors.add(:participant_id, "must accept roster terms and conditions") if !terms_and_conditions
    end
  end

  def self.roster_count_for_team(team_id)
    count(["im_team_id = ?", team_id])
  end

  def self.paid_roster_count_for_team(team_id)
    count(["im_team_id = ? AND paid = ?", team_id, true])
  end
end
