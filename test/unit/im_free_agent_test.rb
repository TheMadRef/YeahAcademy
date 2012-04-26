require File.dirname(__FILE__) + '/../test_helper'

class ImFreeAgentTest < Test::Unit::TestCase
  fixtures :im_free_agents
  fixtures :participants

  # Replace this with your real tests.
  def test_validation
    # No data at all
    no_data = ImFreeAgent.new
    assert !no_data.save
    assert no_data.errors.invalid?(:participant_id)
    assert_equal ["can't be blank", "Must be added to either a league or division"], no_data.errors.on(:participant_id)

    
    #Participant ID with no division/league
    no_data.participant_id = 1
    assert !no_data.save
    assert_equal "Must be added to either a league or division", no_data.errors.on(:participant_id)

    #Duplicate entry into league
    invalid_participant = ImFreeAgent.new(:participant_id => im_free_agents(:free_agent_for_league).participant_id, 
                        :im_league_id => im_free_agents(:free_agent_for_league).im_league_id)
    assert !invalid_participant.save
    assert_equal "already taken", invalid_participant.errors.on(:participant_id)

    #Duplicate entry into division
    invalid_participant = ImFreeAgent.new(:participant_id => im_free_agents(:free_agent_for_division).participant_id, 
                        :im_division_id => im_free_agents(:free_agent_for_division).im_division_id)
    assert !invalid_participant.save
    assert_equal "already taken", invalid_participant.errors.on(:participant_id)

    #Valid entry
    valid_participant = ImFreeAgent.new(:participant_id => 3, :im_league_id => 1)
    assert valid_participant.save

    valid_participant = ImFreeAgent.new(:participant_id => 3, :im_division_id => 1)
    assert valid_participant.save
  end
end
