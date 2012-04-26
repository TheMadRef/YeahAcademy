require File.dirname(__FILE__) + '/../test_helper'

class ImDivisionTest < Test::Unit::TestCase
  fixtures :im_divisions

  # Replace this with your real tests.
  fixtures :terms
  fixtures :im_sports
  fixtures :im_leagues
  fixtures :im_divisions
  fixtures :im_teams

  def test_error_validation
    # Testing not including valid data
    no_data = ImDivision.new
    assert !no_data.save
    assert no_data.errors.invalid?(:im_league_id)
    assert no_data.errors.invalid?(:division_name)
    assert no_data.errors.invalid?(:start_time)
    assert no_data.errors.invalid?(:end_time)
    assert_equal ["is not a number", "should be greater than one"], no_data.errors.on(:number_of_teams)

    # Invalid Data (Invalid entry for number_of teams, end time lower than start time)
    bad_division = ImDivision.new(:division_name => "Test Division",
    :im_league_id => im_divisions(:empty_division).im_league_id,
    :number_of_teams => -4,
    :start_time => "18:00", 
    :end_time => "17:00")
    assert !bad_division.save
    assert_equal "should be greater than one", bad_division.errors.on(:number_of_teams)
    assert_equal "should be greater than Start Time", bad_division.errors.on(:end_time)

    # Fix division name, but keep putting invalid numbers for number of teams and end time = start time
    bad_division.division_name = "Test Division"
    bad_division.number_of_teams = 0
    bad_division.end_time = "18:00"
    assert !bad_division.save
    assert_equal "should be greater than one", bad_division.errors.on(:number_of_teams)
    assert_equal "should be greater than Start Time", bad_division.errors.on(:end_time)
    
    # End time now greater than start time, but number of divisions still invalid
    bad_division.number_of_teams = 1
    bad_division.end_time = "19:00"
    assert !bad_division.save
    assert_equal "should be greater than one", bad_division.errors.on(:number_of_teams)

    # Valid Data
    bad_division.number_of_teams = 5
    assert bad_division.valid?
  end
  
  def test_cutting_number_of_teams
    test_division = im_divisions(:full_division)
    test_division.number_of_teams = 4
    assert !test_division.save
    assert_equal "can not be lower than existing team number", test_division.errors.on(:number_of_teams)
    team_to_delete = ImTeam.find(im_teams(:team_for_division_3).id)
    assert team_to_delete.destroy
    assert !test_division.save
    assert_equal "can not be lower than existing team number", test_division.errors.on(:number_of_teams)
    team_to_change_number = ImTeam.find(im_teams(:team_for_division_5).id)
    team_to_change_number.team_number = 3
    assert team_to_change_number.save
    assert test_division.save
  end

  def test_unique_division_names
    #Should not be able to add duplicate division names for the same sport...
    bad_division = ImDivision.new(:division_name => im_divisions(:empty_division).division_name,
    :im_league_id => im_divisions(:empty_division).im_league_id,
    :number_of_teams => 3,
    :start_time => "18:00", 
    :end_time => "19:00")
    assert !bad_division.save
    assert_equal "duplicate division name in sport", bad_division.errors.on(:division_name)

    #but should be able to add the division to another sport even using the same name
    good_division = ImDivision.new(:division_name => im_divisions(:empty_division).division_name,
    :im_league_id => im_leagues(:league_in_another_sport).id,
    :number_of_teams => 3,
    :start_time => "18:00", 
    :end_time => "19:00")
    assert good_division.save
  end
end
