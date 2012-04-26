class ParticipantMembership < ActiveRecord::Base
	belongs_to :participant
	belongs_to :participant_contract
end
