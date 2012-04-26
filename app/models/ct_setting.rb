class CtSetting < ActiveRecord::Base
  validates_presence_of :system_name
  validates_presence_of :master_ct_terms_and_conditions_text, :if => :master_ct_terms_and_conditions
  validates_presence_of :class_terms_and_conditions_text, :if => :class_terms_and_conditions
  validates_numericality_of :participant_limit_per_class, :participant_overall_limit, :only_integer => true
  def validate
    errors.add(:participant_limit_per_class, "should be greater than zero" ) if participant_limit_per_class.nil? || participant_limit_per_class < 1
    errors.add(:participant_overall_limit, "should be greater than zero" ) if participant_overall_limit.nil? || participant_overall_limit < 1
  end      
end
