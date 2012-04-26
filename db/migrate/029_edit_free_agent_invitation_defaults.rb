class EditFreeAgentInvitationDefaults < ActiveRecord::Migration
  def self.up
    change_column :im_free_agent_invitations, :accepted, :boolean, {:default => false}
    change_column :im_free_agent_invitations, :declined, :boolean, {:default => false}
  end

  def self.down
  end
end
