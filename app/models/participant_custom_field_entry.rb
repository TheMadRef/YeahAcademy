class ParticipantCustomFieldEntry < ActiveRecord::Base
	belongs_to :participant
	belongs_to :participant_custom_field
	has_one :participant_form_order	
end
