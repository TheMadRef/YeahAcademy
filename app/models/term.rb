class Term < ActiveRecord::Base
  has_many :im_sports, :order => "sport_name", :dependent => :destroy
  has_many :ct_classes, :order => "class_name", :dependent => :destroy

  validates_presence_of :term_name
  validates_uniqueness_of :term_name
  validates_numericality_of :default_class_roster_maximum, :only_integer => true, :allow_nil => true
  validates_numericality_of :default_class_price, :default_class_late_price, :default_class_early_bird_discount, :allow_nil => true
	validates_numericality_of :default_class_minimum_age, :default_class_maximum_age, :only_integer => true, :if => :validate_age_requirements?
	  
  def validate
    # if we have a registration start date then check end date
    # also need to check late and discount dates
    # IMTrack ignores registration dates for terms so it will be nil
    if not default_class_registration_start.nil?
      errors.add(:default_class_registration_end, "should be greater than Start Date" ) if default_class_registration_end.nil? || default_class_registration_end <= default_class_registration_start
      errors.add(:default_class_early_bird_date, "should be greater than or equal to Registration Start" ) if default_class_early_bird_date.nil? || default_class_early_bird_date < default_class_registration_start
      errors.add(:default_class_early_bird_date, "should be less than Registration End" ) if default_class_early_bird_date.nil? ||default_class_early_bird_date > default_class_registration_end
      errors.add(:default_class_early_bird_date, "should be less than Late Date" ) if default_class_early_bird_date.nil? ||default_class_early_bird_date > default_class_late_date
      errors.add(:default_class_late_date, "should be greater than or equal to Registration Start" ) if default_class_late_date.nil? || default_class_late_date < default_class_registration_start
      errors.add(:default_class_late_date, "should be less than Registration End" ) if default_class_late_date.nil? ||default_class_late_date > default_class_registration_end
      errors.add(:default_class_price, "should be at least 0.00" ) if default_class_price.nil? || default_class_price < 0.00
      errors.add(:default_class_late_fee, "should be at least 0.00" ) if default_class_late_price.nil? || default_class_late_price < 0.00
      errors.add(:default_class_early_bird_discount, "should be at least 0.00" ) if default_class_early_bird_discount.nil? || default_class_early_bird_discount < 0.00
      errors.add(:default_class_roster_maximum, "should be greater than zero" ) if default_class_roster_maximum.nil? || default_class_roster_maximum < 1
			if !$g_set_number_of_days_to_pay
      	errors.add(:default_class_payment_due_date, "should be greater or equal to the Registration End" ) if default_class_payment_due_date.nil? || default_class_payment_due_date < default_class_registration_end	
			end
			if $g_require_DOB
				errors.add(:default_class_minimum_age, "should be at least 0") if default_class_minimum_age.nil? || default_class_minimum_age < 0
				errors.add(:default_class_maximum_age, "should be at least 0") if default_class_maximum_age.nil? || default_class_maximum_age < 0
				errors.add(:default_class_maximum_age, "should be greater or equal to the default age minimum") if default_class_minimum_age.nil? || default_class_maximum_age.nil? || default_class_maximum_age < default_class_minimum_age
			end
    end
  end
  
  def self.copy_term(old_term_id, new_term)
    ct_classes = CtClass.find(:all, :conditions =>["term_id = ?", old_term_id])
    for ct_class in ct_classes
      @ct_class = CtClass.new(ct_class.attributes)
      @ct_class.term_id = new_term.id
      @ct_class.registration_start = new_term.default_class_registration_start
      @ct_class.registration_end = new_term.default_class_registration_end
      @ct_class.default_late_date = new_term.default_class_late_date
      @ct_class.default_early_bird_date = new_term.default_class_early_bird_date
      @ct_class.default_payment_due_date = new_term.default_class_payment_due_date
      @ct_class.save!
      ct_class_terms_and_conditions = CtClassTermAndCondition.find(:first, :conditions => ["ct_class_id = ?", ct_class.id])
      if !ct_class_terms_and_conditions.nil?
        @ct_class_terms_and_conditions = CtClassTermAndCondition.new(ct_class_terms_and_conditions.attributes)
        @ct_class_terms_and_conditions.ct_class_id = @ct_class.id
        @ct_class_terms_and_conditions.save!
      end
      ct_sessions = ct_class.ct_sessions.find(:all)
      for session in ct_sessions
        @ct_session = CtSession.new(session.attributes)
        @ct_session.ct_class_id = @ct_class.id
        @ct_session.s_registration_start = new_term.default_class_registration_start
        @ct_session.s_registration_end = new_term.default_class_registration_end
        @ct_session.s_late_date = new_term.default_class_late_date
        @ct_session.s_early_bird_date = new_term.default_class_early_bird_date
        @ct_session.s_payment_due_date = new_term.default_class_payment_due_date
        @ct_session.save!
        ct_session_category_restrictions = session.ct_session_category_restrictions.find(:all)
        for category_restriction in ct_session_category_restrictions
          @ct_session_category_restriction = CtSessionCategoryRestriction.new(category_restriction.attributes)
          @ct_session_category_restriction.ct_session_id = @ct_session.id
          @ct_session_category_restriction.save!
        end
      end
    end
  end
   
    protected
  
  def validate_age_requirements?
  	return $g_require_DOB
  end
end