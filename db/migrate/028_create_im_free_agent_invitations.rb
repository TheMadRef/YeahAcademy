class CreateImFreeAgentInvitations < ActiveRecord::Migration
  def self.up
    create_table :im_free_agent_invitations do |t|
      t.column :im_free_agent_id, :integer
      t.column :im_team_id, :integer
      t.column :declined, :boolean
      t.column :accepted, :boolean
    end
  end

  def self.down
    drop_table :im_free_agent_invitations
  end
end
