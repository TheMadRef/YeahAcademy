class CtRoster < ActiveRecord::Base
  belongs_to :ct_session
  belongs_to :participant
  has_one :line_item
  
  validates_presence_of :participant_id, :message => "could not be found in participant database"
  validates_presence_of :ct_session_id
  validates_uniqueness_of :participant_id, :scope => :ct_session_id, :message => "has already been added to roster"

  def validate
    # Validate eligibility    
    if !participant_id.nil? && $g_verify_ct_eligibility
      errors.add(:participant_id, "not eligible") if !participant.ct_active
    end

    if !ct_session_id.nil?
	    #validate that class is not over the roster limit
      roster_count = CtRoster.roster_count_for_class_session_with_participant(ct_session_id, participant_id)
      if roster_count >= ct_session.s_roster_maximum
        errors.add(:ct_session_id, "has reached roster maximum")
      end        

      # Validating against participant limits, first overall, then per class
      if CtRoster.count(:conditions => ["participant_id = ? AND ct_session_id <> ?", participant_id, ct_session_id]) >= $g_participant_overall_limit
        errors.add(:participant_id, "already has signed up for the maximum allowed number of classes")
      end
      if CtRoster.count(:joins => "INNER JOIN ct_sessions on ct_rosters.ct_session_id = ct_sessions.id", :conditions => ["ct_rosters.participant_id = ? AND ct_rosters.ct_session_id <> ? AND ct_sessions.ct_class_id = ?", participant_id, ct_session_id, ct_session.ct_class_id]) >= $g_participant_limit_per_class
        errors.add(:participant_id, "already has signed up for the maximum allowed number of sessions for this class")
      end
      
      # Validating against age requirements
      if $g_require_DOB
      	if participant.date_of_birth.nil?
      		errors.add(:participant_id, "must have a valid date of birth.  Edit your profile to resolve this.")
      	else
      	  if Date.new(Date.today.year.to_i, 6, 1) < Date.today
      		  comparison_date = Date.new(Date.today.year.to_i,12,31)
      		else
	      		comparison_date = Date.new(Date.today.year.to_i - 1,12,31)
      		end
      		participant_age = (comparison_date - participant.date_of_birth).to_i / 365
      		errors.add(:participant_id, "is older than the maximum age allowed for this class") if participant_age > ct_session.s_maximum_age
      		errors.add(:participant_id, "is younger than the minimum age allowed for this class") if participant_age < ct_session.s_minimum_age
      	end
      end
    end    

    # now validating that the user has accepted the master terms and conditions
    if !participant_id.nil? && $g_master_ct_terms_and_conditions
      errors.add(:participant_id, "must accept class master terms and conditions") if !participant.ct_terms_and_conditions
    end
    
    # now validate that member accepted terms and conditions to join classes
    if !participant_id.nil?  && $g_class_terms_and_conditions
      errors.add(:participant_id, "must accept terms and conditions to join class") if !terms_and_conditions
    end
    
    if !paid && approved
      errors.add(:approved, "can not approve un-paid class")
    end
    
    # now validate that the users category is not restricted
	if !participant.nil?
	    if !participant.category_id.nil?
    		errors.add(:participant_id, " belongs to a category that is not allowed for this class") if CtSession.is_category_restricted?(ct_session_id, participant.category_id)
    	end
    end
  end

  def require_payment
    return !paid
  end
  
  def self.roster_count_for_class_session(ct_session_id)
    count(["ct_session_id = ?", ct_session_id])
  end

  def self.roster_count_for_class_session_with_participant(ct_session_id, participant_id)
    count(["ct_session_id = ? AND participant_id != ?", ct_session_id, participant_id])
  end
end