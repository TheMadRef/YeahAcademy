require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < Test::Unit::TestCase
  fixtures :participants

  # Replace this with your real tests.
  def test_error_validation
    # Testing not including valid data
    $g_admin = false
    no_data = Participant.new
    assert !no_data.save
    assert no_data.errors.invalid?(:participant_number)
    assert no_data.errors.invalid?(:first_name)
    assert no_data.errors.invalid?(:last_name)
    assert no_data.errors.invalid?(:email)

    # Invalid Data (Duplicate Member ID (encrypted))
    bad_participant = Participant.new(:member_id => participants(:Miguel).member_id,
    :first_name => participants(:Miguel).first_name,
    :last_name => participants(:Miguel).last_name,
    :email => participants(:Miguel).email)
    assert !bad_participant.save
    assert_equal "has already been taken" , bad_participant.errors.on(:member_id)
    
    # Invalid Data, this time entering the participant number
    another_bad_participant = Participant.new(:participant_number => "12345",
    :first_name => participants(:Miguel).first_name,
    :last_name => participants(:Miguel).last_name,
    :email => participants(:Miguel).email)
    assert !another_bad_participant.save
    assert_equal "already in database" , another_bad_participant.errors.on(:participant_number)
    
    # Valid Data
    valid_participant = Participant.new(:participant_number => "12121",
    :first_name => participants(:Miguel).first_name,
    :last_name => participants(:Miguel).last_name,
    :email => participants(:Miguel).email)
    assert valid_participant.save
  end
  
  def test_email_required
    #System should require email address for non admins, currently using $g_admin
    $g_admin = false
    email_check_participant = Participant.new(:participant_number => "13131",
    :first_name => participants(:Miguel).first_name,
    :last_name => participants(:Miguel).last_name)
    assert !email_check_participant.save
    assert email_check_participant.errors.invalid?(:email)
    #Set admin to true and re-save
    $g_admin = true
    assert email_check_participant.save
  end

  def test_email_required
    #System should require email address for non admins, currently using $g_admin
    $g_admin = false
    email_check_participant = Participant.new(:participant_number => "13131",
    :first_name => participants(:Miguel).first_name,
    :last_name => participants(:Miguel).last_name)
    assert !email_check_participant.save
    assert email_check_participant.errors.invalid?(:email)
    #Set admin to true and re-save
    $g_admin = true
    assert email_check_participant.save
  end

end
