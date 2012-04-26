class CtInstructor < ActiveRecord::Base
	belongs_to :participant
	has_many :ct_sessions, :dependent => :nullify
	
	validates_presence_of :participant_id, :google_account
	validates_uniqueness_of :participant_id
end
