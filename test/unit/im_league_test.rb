require File.dirname(__FILE__) + '/../test_helper'

class ImLeagueTest < Test::Unit::TestCase
  fixtures :terms
  fixtures :im_sports
  fixtures :im_leagues
  fixtures :im_teams

  def test_error_validation
    # Testing not including valid data
    no_data = ImLeague.new
    assert !no_data.save
    assert no_data.errors.invalid?(:im_sport_id)
    assert no_data.errors.invalid?(:league_name)

    # Invalid Data (Invalid entries for max teams/league and parent_id)
    bad_league = ImLeague.new(:league_name => im_leagues(:full_league_for_teams).league_name,
    :im_sport_id => im_leagues(:full_league_for_teams).im_sport_id,
    :max_allowed => -4,
    :parent_id => -4)
    assert !bad_league.save
    assert_equal "should be zero or greater", bad_league.errors.on(:max_allowed)
    assert_equal "should be zero or greater", bad_league.errors.on(:parent_id)
    
    # Fix league name, but non integer values for parent_id and max_allowed
    bad_league.parent_id = 2.5
    bad_league.max_allowed = 3.5
    assert !bad_league.save
    assert_equal "is not a number", bad_league.errors.on(:max_allowed)
    assert_equal "is not a number", bad_league.errors.on(:parent_id)
    
    # Verify duplicate league name
    bad_league.parent_id = 0
    bad_league.max_allowed = 5
    assert !bad_league.save
    assert_equal "has already been taken" , bad_league.errors.on(:league_name)

    # Valid Data
    bad_league.league_name = "B League"
    assert bad_league.valid?
  end
  
  def test_cutting_number_of_teams
    test_league = im_leagues(:full_league_for_teams)
    test_league.max_allowed = 4
    assert !test_league.save
    assert_equal "can not be lower than existing team number", test_league.errors.on(:max_allowed)
    team_to_delete = ImTeam.find(im_teams(:team_for_league_3).id)
    assert team_to_delete.destroy
    assert !test_league.save
    assert_equal "can not be lower than existing team number", test_league.errors.on(:max_allowed)
    team_to_change_number = ImTeam.find(im_teams(:team_for_league_5).id)
    team_to_change_number.team_number = 3
    assert team_to_change_number.save
    assert test_league.save
  end
end
