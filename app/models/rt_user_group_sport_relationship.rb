class RtUserGroupSportRelationship < ActiveRecord::Base
  belongs_to :rt_user_group
  belongs_to :im_sport

  validates_presence_of :im_sport_id, :rt_user_group_id
  validates_uniqueness_of :im_sport_id, :scope => :rt_user_group_id
end
