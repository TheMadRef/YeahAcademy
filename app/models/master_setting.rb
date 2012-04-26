class MasterSetting < ActiveRecord::Base
  
  validates_presence_of :master_terms_and_conditions_text, :if => :master_terms_and_conditions
	validates_presence_of :default_payment_due_days, :if => :default_payment_due_setting
  validates_numericality_of :default_payment_due_days, :only_integer => true, :if => :default_payment_due_setting
  validates_numericality_of :membership_fee, :application_fee
  
  def validate
  	if default_payment_due_setting
      errors.add(:default_payment_due_days, "should be greater than zero" ) if default_payment_due_days.nil? || default_payment_due_days < 1
			if require_membership_fee
				errors.add(:membership_fee, " or application fee must be greater than zero" ) if membership_fee.nil? || application_fee.nil? || (membership_fee <= 0 && application_fee <= 0)
				errors.add(:membership_fee, " must be a valid currency amount") if membership_fee.nil? || membership_fee < 0
				errors.add(:application_fee, " must be a valid currency amount") if application_fee.nil? || application_fee < 0
			end
		end	
	end  
end
	