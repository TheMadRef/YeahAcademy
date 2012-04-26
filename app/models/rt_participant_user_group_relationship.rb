class RtParticipantUserGroupRelationship < ActiveRecord::Base
  belongs_to :participant
  belongs_to :rt_user_group
  
  validates_presence_of :participant_id, :rt_user_group_id
  validates_uniqueness_of :participant_id, :scope => :rt_user_group_id
end
