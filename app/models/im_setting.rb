class ImSetting < ActiveRecord::Base
  has_one :im_payment_option

  validates_presence_of :system_name
  validates_presence_of :master_im_terms_and_conditions_text, :if => :master_im_terms_and_conditions
  validates_presence_of :team_terms_and_conditions_text, :if => :team_terms_and_conditions
  validates_presence_of :roster_terms_and_conditions_text, :if => :roster_terms_and_conditions
  validates_numericality_of :captain_limit_per_division, :captain_limit_per_league, :captain_limit_per_sport, :overall_captain_limit, :only_integer => true
  def validate
    errors.add(:captain_limit_per_division, "should be greater than zero" ) if captain_limit_per_division.nil? || captain_limit_per_division < 1
    errors.add(:captain_limit_per_league, "should be greater than zero" ) if captain_limit_per_league.nil? || captain_limit_per_league < 1
    errors.add(:overall_captain_limit, "should be greater than zero" ) if overall_captain_limit.nil? || overall_captain_limit < 1
    errors.add(:captain_limit_per_sport, "should be greater than zero" ) if captain_limit_per_sport.nil? || captain_limit_per_sport < 1    
    errors.add(:participant_roster_limit_per_sport, "should be greater than zero" ) if participant_roster_limit_per_sport.nil? || participant_roster_limit_per_sport < 1    
    errors.add(:participant_roster_limit_per_league, "should be greater than zero" ) if captain_limit_per_sport.nil? || participant_roster_limit_per_league < 1    
  end      
end
