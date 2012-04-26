require File.dirname(__FILE__) + '/../test_helper'

class ImFreeAgentInvitationTest < Test::Unit::TestCase
  fixtures :im_free_agent_invitations

  # Replace this with your real tests.
  def test_only_one_invitation_per_team
    duplicate_invitation = ImFreeAgentInvitation.new(:im_free_agent_id => im_free_agent_invitations(:invitation_from_division_team).im_free_agent_id,
        :im_team_id => im_free_agent_invitations(:invitation_from_division_team).im_team_id)
    assert !duplicate_invitation.save
    assert_equal "has already been taken" , duplicate_invitation.errors.on(:im_free_agent_id)
    #change team number and should save
    duplicate_invitation.im_team_id = 10
    assert duplicate_invitation.save
  end

  def test_do_not_approve_declined_invitations
    declined_invitation = ImFreeAgentInvitation.find(im_free_agent_invitations(:declined_invitation).id)
    declined_invitation.accepted = 1
    assert !declined_invitation.save
    assert_equal "not allowed if invitation already declined" , declined_invitation.errors.on(:accepted)    
  end

  def test_do_not_decline_approved_invitations
    accepted_invitation = ImFreeAgentInvitation.find(im_free_agent_invitations(:accepted_invitation).id)
    accepted_invitation.declined = 1
    assert !accepted_invitation.save
    assert_equal "not allowed if invitation already declined" , accepted_invitation.errors.on(:accepted)    
  end
end
