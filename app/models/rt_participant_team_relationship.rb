class RtParticipantTeamRelationship < ActiveRecord::Base
  belongs_to :im_team
  belongs_to :participant
  belongs_to :rt_user_group
  
  validates_presence_of :participant_id, :im_team_id, :rt_user_group_id
  validates_uniqueness_of :im_team_id, :scope => :rt_user_group_id
  
end
