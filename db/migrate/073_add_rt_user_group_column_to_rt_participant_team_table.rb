class AddRtUserGroupColumnToRtParticipantTeamTable < ActiveRecord::Migration
  def self.up
    add_column :rt_participant_team_relationships, :rt_user_group_id, :integer
  end

  def self.down
    remove_column :rt_participant_team_relationships, :rt_user_group_id
  end
end
