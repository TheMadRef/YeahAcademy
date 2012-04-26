class ParticipantCustomField < ActiveRecord::Base
	has_many :participant_custom_field_entries, :dependent => :destroy
	has_one :participant_form_order, :dependent => :destroy
	
  validates_presence_of :field_name
  validates_uniqueness_of :field_name
  
end
