class RtParticipantFacilityBlock < ActiveRecord::Base
  belongs_to :facility
  belongs_to :participant

  validates_presence_of :participant_id, :facility_id
  validates_uniqueness_of :participant_id, :scope => :facility_id
end
