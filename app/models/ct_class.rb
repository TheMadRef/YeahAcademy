class CtClass < ActiveRecord::Base
  has_many :ct_sessions, :dependent => :destroy, :order => :s_class_name
  has_one :ct_class_term_and_condition, :dependent => :destroy
  belongs_to :term

  validates_presence_of :class_name, :abbreviation, :registration_start, :registration_end, :default_late_date
  validates_uniqueness_of :class_name, :scope => :term_id, :case_sensitive => false
  validates_numericality_of :default_roster_maximum, :only_integer => true
  validates_numericality_of :default_price, :default_late_fee, :default_early_bird_discount
	validates_numericality_of :default_minimum_age, :default_maximum_age, :only_integer => true, :if => :validate_age_requirements?
  
  def validate
    errors.add(:registration_end, "should be greater than Registration Start" ) if registration_end <= registration_start
    errors.add(:default_early_bird_date, "should be greater than or equal to Registration Start" ) if default_early_bird_date.nil? || default_early_bird_date < registration_start
    errors.add(:default_early_bird_date, "should be less than Registration End" ) if default_early_bird_date.nil? ||default_early_bird_date > registration_end
    errors.add(:default_early_bird_date, "should be less than Late Date" ) if default_early_bird_date.nil? ||default_early_bird_date > default_late_date
    errors.add(:default_late_date, "should be greater than or equal to Registration Start" ) if default_late_date < registration_start
    errors.add(:default_late_date, "should be less than Registration End" ) if default_late_date > registration_end
    errors.add(:default_price, "should be at least 0.00" ) if default_price.nil? || default_price < 0.00
    errors.add(:default_early_bird_discount, "should be at least 0.00" ) if default_early_bird_discount.nil? || default_early_bird_discount < 0.00
    errors.add(:default_late_fee, "should be at least 0.00" ) if default_late_fee.nil? || default_late_fee < 0.00
    errors.add(:default_roster_maximum, "should be greater than zero" ) if default_roster_maximum.nil? || default_roster_maximum < 1
		if !$g_set_number_of_days_to_pay
    	errors.add(:default_payment_due_date, "should be greater or equal to the Registration End" ) if default_payment_due_date.nil? ||default_payment_due_date < registration_end	
		end
		if $g_require_DOB
			errors.add(:default_minimum_age, "should be at least 0") if default_minimum_age.nil? || default_minimum_age < 0
			errors.add(:default_maximum_age, "should be at least 0") if default_maximum_age.nil? || default_maximum_age < 0
			errors.add(:default_maximum_age, "should be greater or equal to the default age minimum") if default_minimum_age.nil? || default_maximum_age.nil? || default_maximum_age < default_minimum_age
		end
  end

  def self.class_term_and_conditions_text(ct_class_id)
    if ct_class_id == 0
      term_and_conditions = CtSetting.find(1).class_terms_and_conditions_text
    else
      term_and_conditions_record = CtClassTermAndCondition.find(:first, :conditions => ["ct_class_id = ?", ct_class_id])
      if term_and_conditions_record.nil?
        term_and_conditions = CtSetting.find(1).class_terms_and_conditions_text
      else
        term_and_conditions = term_and_conditions_record.terms_and_conditions
      end
    end
    return term_and_conditions
  end 

	protected
	
  def validate_age_requirements?
  	return $g_require_DOB
  end
end
