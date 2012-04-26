class CtClassTermAndCondition < ActiveRecord::Base
  belongs_to :ct_class
  
  validates_presence_of :ct_class_id, :message => "can not be blank"
  validates_presence_of :terms_and_conditions, :message => "can not be blank", :if => :validate_terms_and_conditions

  def validate_terms_and_conditions
    if $g_class_terms_and_conditions
      return true
    else
      return false
    end
  end
end
