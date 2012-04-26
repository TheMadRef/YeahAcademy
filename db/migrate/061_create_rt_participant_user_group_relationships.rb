class CreateRtParticipantUserGroupRelationships < ActiveRecord::Migration
  def self.up
    create_table :rt_participant_user_group_relationships do |t|
      t.column :rt_user_group_id, :integer
      t.column :participant_id, :integer
      t.column :im_team_id, :integer
      t.column :active, :boolean
    end
  end

  def self.down
    drop_table :rt_participant_user_group_relationships
  end
end
