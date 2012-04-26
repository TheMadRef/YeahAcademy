class CreateRtParticipantTeamRelationships < ActiveRecord::Migration
  def self.up
    create_table :rt_participant_team_relationships do |t|
      t.column :participant_id, :integer
      t.column :im_team_id, :integer
    end
  end

  def self.down
    drop_table :rt_participant_team_relationships
  end
end
