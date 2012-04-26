class RtMemoUserGroupRelationship < ActiveRecord::Base
  belongs_to :rt_user_group
  belongs_to :rt_memo
end
