class ImRosterTermAndCondition < ActiveRecord::Base
  belongs_to :im_sport
  
  validates_presence_of :im_sport_id, :message => "can not be blank"
  validates_presence_of :terms_and_conditions, :message => "can not be blank", :if => :validate_terms_and_conditions

  def validate_terms_and_conditions
    if $g_roster_terms_and_conditions
      return true
    else
      return false
    end
  end
end
