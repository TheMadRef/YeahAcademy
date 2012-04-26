class ParticipantFormOrder < ActiveRecord::Base
	belongs_to :participant_custom_field
	
	validates_uniqueness_of :participant_custom_field_id, :allow_nil => true
	validates_uniqueness_of :participant_column_human_name, :allow_nil => true
	validates_uniqueness_of :sort_number, :if => :verify_sort_number?
	validates_uniqueness_of :participant_column_name, :allow_nil => true
	validates_numericality_of :sort_number
  validates_length_of :participant_column_human_name, :within => 2..50, :too_long => "is over the limit of 50 character", :too_short => "needs to be at least 2 characters long", :if => :verify_field_name?

  protected
    # before filter 
		def verify_field_name?
			return participant_custom_field_id.nil?
		end

		def verify_sort_number?
			return !(sort_number == 0)
		end
end
