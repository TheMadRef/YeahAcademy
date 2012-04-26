class ParticipantTitle < ActiveRecord::Base
	has_many :participants, :dependent => :nullify
end
