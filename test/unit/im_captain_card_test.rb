require File.dirname(__FILE__) + '/../test_helper'

class ImCaptainCardTest < Test::Unit::TestCase
  fixtures :im_captain_cards
  fixtures :participants

  def test_error_validation_on_create
    # new record should have password assigned
    no_data = ImCaptainCard.new
    assert !no_data.save
    assert_equal ["the team password should be at least 6 characters long", "can not be blank"], no_data.errors.on(:basic_password)
    
    # Testing that the password be at least 6 but no greater than 16
    invalid_data = ImCaptainCard.new(:basic_password => "short")
    assert !invalid_data.save
    assert_equal "the team password should be at least 6 characters long", invalid_data.errors.on(:basic_password)

    invalid_data.basic_password = "wayy2longpassword"
    assert !invalid_data.save
    assert_equal "the team password is longer than 16 characters", invalid_data.errors.on(:basic_password)

    # Now creat two valid cards, one for each limit
    valid_data = ImCaptainCard.new(:basic_password => "equal6")
    assert valid_data.valid?
    
    vald_data = ImCaptainCard.new(:basic_password => "exactly16letters")
    assert valid_data.valid?
  end
  
  def test_adding_participant_to_card
    #testing duplicate card for participant
    test_card = im_captain_cards(:card_without_participant)
    test_card.participant_id = im_captain_cards(:card_with_assigned_participant).participant_id
    assert !test_card.save
    assert_equal "has a captain card assigned already", test_card.errors.on(:participant_id) 
    
    #Testing im active status
    invalid_captain = im_captain_cards(:card_without_participant)
    invalid_captain.participant = Participant.find(participants(:Not_IM_Eligible).id)
    assert !invalid_captain.save
    assert_equal "not eligible", invalid_captain.errors.on(:participant_id) 

    #Testing Valid User
    valid_captain = im_captain_cards(:card_without_participant)
    valid_captain.participant = Participant.find(participants(:Kristi).id)
    assert valid_captain.save
  end
end
