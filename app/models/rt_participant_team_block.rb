class RtParticipantTeamBlock < ActiveRecord::Base
  belongs_to :facility
  belongs_to :im_team

  validates_presence_of :participant_id, :im_team_id
  validates_uniqueness_of :participant_id, :scope => :im_team_id

end
