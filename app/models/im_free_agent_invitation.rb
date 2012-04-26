class ImFreeAgentInvitation < ActiveRecord::Base
  belongs_to :im_free_agent
  belongs_to :im_team
  
  validates_uniqueness_of :im_free_agent_id, :scope => :im_team_id

  def validate
    errors.add(:accepted, "not allowed if invitation already declined") if accepted? && declined?
  end
end
