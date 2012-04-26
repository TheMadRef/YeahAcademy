class ParticipantContract < ActiveRecord::Base
	has_many :participant_memberships, :dependent => :destroy
end
