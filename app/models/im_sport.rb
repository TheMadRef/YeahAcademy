class ImSport < ActiveRecord::Base
  has_many :im_leagues, :order => "league_name", :dependent => :destroy
  has_many :im_brackets, :dependent => :destroy
  has_many :im_day_of_plays, :order =>"dop_name", :dependent => :destroy
  has_one :im_team_term_and_condition, :dependent => :destroy
  has_one :im_roster_term_and_condition, :dependent => :destroy
  has_many :im_column_headers, :dependent => :destroy
  has_many :rt_user_group_sport_relationships, :dependent => :destroy
  has_many :rt_employee_titles, :dependent => :destroy
  has_one :im_game_of_the_day, :dependent => :destroy
  has_many :im_rankings, :dependent => :destroy
  has_many :im_statistics, :dependent => :destroy
  has_one :im_web_setting_color, :dependent => :destroy
  belongs_to :term

  validates_presence_of :sport_name, :start_date, :end_date, :roster_end_date, :term_id
  validates_inclusion_of :jersey_color, :in => [true, false]
  validates_numericality_of :price, :allow_nil => false
  validates_numericality_of :roster_price, :allow_nil => false
  validates_numericality_of :default_hour, :only_integer => true
  validates_numericality_of :default_minute, :only_integer => true  
  validates_numericality_of :roster_minimum, :allow_nil => false, :only_integer => true
  validates_numericality_of :roster_maximum, :allow_nil => false, :only_integer => true  
  validates_uniqueness_of :sport_name, :scope => :term_id, :case_sensitive => false

  def validate
    errors.add(:end_date, "should be greater than Start Date" ) if end_date.nil? || end_date <= start_date
    errors.add(:roster_end_date, "should be greater than or equal to End Date" ) if roster_end_date.nil? || roster_end_date < end_date
    errors.add(:price, "should be at least 0.00" ) if price.nil? || price < 0.00
    errors.add(:roster_price, "should be at least 0.00" ) if roster_price.nil? || roster_price < 0.00
    errors.add(:default_hour, "should be at least 0" ) if default_hour.nil? || default_hour < 0
    errors.add(:default_minute, "should be at least 0" ) if default_minute.nil? || default_minute < 0
    errors.add(:default_hour, "should be less than 11" ) if default_hour.nil? || default_hour > 11
    errors.add(:default_minute, "should be less than 59" ) if default_minute.nil? || default_minute > 59
    errors.add(:roster_minimum, "should be greater than zero" ) if roster_minimum.nil? || roster_minimum < 1
		if !$g_set_number_of_days_to_pay
    	errors.add(:payment_due_date, "should be greater or equal to the Registration End Date" ) if payment_due_date.nil? || payment_due_date < end_date
    	if !roster_price.nil?
    		errors.add(:payment_due_date, "should be greater or equal to the Roster End Date" ) if roster_price > 0.00 && (payment_due_date.nil? || payment_due_date < roster_end_date)
    	end	
		end
    # only check max if we have a min
    if not roster_minimum.nil?
      errors.add(:roster_maximum, "should be greater than or equal to Roster Minimum" ) if roster_maximum.nil? || roster_maximum < roster_minimum
    end
  end

  def self.team_term_and_conditions_text(im_sport_id)
    if im_sport_id == 0
      term_and_conditions = ImSetting.find(1).team_terms_and_conditions_text
    else
      term_and_conditions_record = ImTeamTermAndCondition.find(:first, :conditions => ["im_sport_id = ?", im_sport_id])
      if term_and_conditions_record.nil?
        term_and_conditions = ImSetting.find(1).team_terms_and_conditions_text
      else
        term_and_conditions = term_and_conditions_record.terms_and_conditions
      end
    end
    return term_and_conditions
  end 

  def self.roster_term_and_conditions_text(im_sport_id)
    if im_sport_id == 0
      term_and_conditions = ImSetting.find(1).roster_terms_and_conditions_text
    else
      term_and_conditions_record = ImRosterTermAndCondition.find(:first, :conditions => ["im_sport_id = ?", im_sport_id])
      if term_and_conditions_record.nil?
        term_and_conditions = ImSetting.find(1).roster_terms_and_conditions_text
      else
        term_and_conditions = term_and_conditions_record.terms_and_conditions
      end
    end
    return term_and_conditions
  end    
end
