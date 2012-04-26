class RemoveExtraColumnsFromRtParticipantUserGroupRelationships < ActiveRecord::Migration
  def self.up
    remove_column :rt_participant_user_group_relationships, :im_team_id
    remove_column :rt_participant_user_group_relationships, :active
  end

  def self.down
    add_column :rt_participant_user_group_relationships, :im_team_id, :integer
    add_column :rt_participant_user_group_relationships, :active, :boolean
  end
end
