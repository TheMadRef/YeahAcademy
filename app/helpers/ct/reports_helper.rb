module Ct::ReportsHelper
	def print_custom_field_value(participant, custom_field)
		field_data = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", participant, custom_field])
		if field_data.nil?
			return "-"
		else
			return field_data.field_data
		end
	end
	def print_class_sesssion_for_report(participant, class_abbreviation)
		ct_roster = CtRoster.find(:first, :include => [:ct_session => :ct_class], :conditions => ["participant_id = ? AND s_abbreviation LIKE ? AND term_id = ?", participant, class_abbreviation + "%", 7])
		if ct_roster.nil? 
			return "-"
		else
			return ct_roster.ct_session.s_abbreviation
		end
	end		
end
  