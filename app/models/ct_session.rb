class CtSession < ActiveRecord::Base
  has_many :ct_rosters, :dependent => :destroy
  has_many :ct_session_category_restrictions, :dependent => :destroy
  has_one :ct_session_schedule, :dependent => :destroy
  belongs_to :ct_class, :order => :class_name
  belongs_to :ct_instructor
  
  validates_presence_of :s_class_name, :s_abbreviation, :s_registration_start, :s_registration_end, :s_late_date, :ct_instructor_id
  validates_uniqueness_of :s_class_name, :scope => :ct_class_id, :case_sensitive => false
  validates_numericality_of :s_roster_maximum, :only_integer => true
  validates_numericality_of :s_price, :s_late_fee
	validates_numericality_of :s_minimum_age, :s_maximum_age, :only_integer => true, :if => :validate_age_requirements?
  
  def validate
    errors.add(:s_registration_end, "should be greater than Registration Start" ) if s_registration_end <= s_registration_start
    errors.add(:s_early_bird_date, "should be greater than or equal to Registration Start" ) if s_early_bird_date.nil? || s_early_bird_date < s_registration_start
    errors.add(:s_early_bird_date, "should be less than Registration End" ) if s_early_bird_date.nil? ||s_early_bird_date > s_registration_end
    errors.add(:s_early_bird_date, "should be less than Late Date" ) if s_early_bird_date.nil? ||s_early_bird_date > s_late_date
    errors.add(:s_late_date, "should be greater than or equal to Registration Start" ) if s_late_date < s_registration_start
    errors.add(:s_late_date, "should be less than Registration End" ) if s_late_date > s_registration_end
    errors.add(:s_price, "should be at least 0.00" ) if s_price.nil? || s_price < 0.00
    errors.add(:s_early_bird_discount, "should be at least 0.00" ) if s_early_bird_discount.nil? || s_early_bird_discount < 0.00
    errors.add(:s_late_fee, "should be at least 0.00" ) if s_late_fee.nil? || s_late_fee < 0.00
    errors.add(:s_roster_maximum, "should be greater than zero" ) if s_roster_maximum.nil? || s_roster_maximum < 1
		if !$g_set_number_of_days_to_pay
    	errors.add(:s_payment_due_date, "should be greater or equal to the Registration End" ) if s_payment_due_date.nil? ||s_payment_due_date < s_registration_end	
		end
		if $g_require_DOB
			errors.add(:s_minimum_age, "should be at least 0") if s_minimum_age.nil? || s_minimum_age < 0
			errors.add(:s_maximum_age, "should be at least 0") if s_maximum_age.nil? || s_maximum_age < 0
			errors.add(:s_maximum_age, "should be greater or equal to the default age minimum") if s_minimum_age.nil? || s_maximum_age.nil? || s_maximum_age < s_minimum_age
		end
  end
  
  def self.is_category_restricted?(ct_session_id, category_id)
  	return !CtSessionCategoryRestriction.find(:first, :conditions => ["ct_session_id = ? AND category_id = ?", ct_session_id, category_id]).nil?
  end

	protected
	
  def validate_age_requirements?
  	return $g_require_DOB
  end
end
