class ImFreeAgent < ActiveRecord::Base
  belongs_to :participant
  belongs_to :im_league
  belongs_to :im_division
  has_many :im_free_agent_invitations, :dependent => :destroy
  
  validates_presence_of :participant_id
  validates_uniqueness_of :participant_id, :scope => [:im_league_id, :im_division_id]

  def validate
    errors.add(:participant_id, "Must be added to either a league or division") if im_league_id.nil? && im_division_id.nil?
  end
end
