require File.dirname(__FILE__) + '/../test_helper'

class ImSportTest < Test::Unit::TestCase
  fixtures :im_sports
  fixtures :terms

  def test_error_validation
    # Testing not including valid data
    no_data = ImSport.new
    assert !no_data.save
    assert no_data.errors.invalid?(:term_id)
    assert no_data.errors.invalid?(:sport_name)
    assert no_data.errors.invalid?(:start_date)
    assert no_data.errors.invalid?(:end_date)
    assert no_data.errors.invalid?(:roster_end_date)
    assert_equal "is not included in the list" , no_data.errors.on(:require_color)

    # Invalid Data (Duplicate Sport Name, Invalid Dates, missing price/roster minimums)
    bad_sport = ImSport.new(:sport_name => im_sports(:sport_requires_color).sport_name,
    :term_id => im_sports(:sport_requires_color).term_id,
    :start_date => "01-01-2002",
    :end_date => "01-01-2001",
    :roster_end_date => "01-01-2000",
    :require_color => "true")
    assert !bad_sport.save
    assert_equal "has already been taken" , bad_sport.errors.on(:sport_name)
    assert_equal "should be greater than Start Date" , bad_sport.errors.on(:end_date)
    assert_equal "should be greater than or equal to End Date" , bad_sport.errors.on(:roster_end_date)
    
    # Fix dates, but now negative values for price, roster minimum and roster maximum
    bad_sport.end_date = "01-01-2003"
    bad_sport.roster_end_date = "01-01-2004"
    bad_sport.sport_name = "Softball"
    bad_sport.price = "-1"
    bad_sport.roster_minimum = "-1"
    bad_sport.roster_maximum = "-2"
    assert !bad_sport.save
    assert_equal "should be at least 0.00", bad_sport.errors.on(:price)
    assert_equal "should be greater than zero", bad_sport.errors.on(:roster_minimum)
    assert_equal "should be greater than or equal to Roster Minimum", bad_sport.errors.on(:roster_maximum)
    
    # Fix price, but now 0 for roster minimum
    bad_sport.price = "23.99"
    bad_sport.roster_minimum = "0"
    bad_sport.roster_maximum = "0"
    assert !bad_sport.save
    assert_equal "should be greater than zero", bad_sport.errors.on(:roster_minimum)

    # Fix roster minimum, keep roster max under roster min
    bad_sport.roster_minimum = "2"
    bad_sport.roster_maximum = "1"
    assert !bad_sport.save
    assert_equal "should be greater than or equal to Roster Minimum", bad_sport.errors.on(:roster_maximum)

    # Finally, need to make sure the roster min/max are integers
    bad_sport.roster_minimum = "2.5"
    bad_sport.roster_maximum = "3.5"
    assert !bad_sport.save
    assert_equal "is not a number", bad_sport.errors.on(:roster_minimum)
    assert_equal "is not a number", bad_sport.errors.on(:roster_maximum)
    
    # Valid Data
    bad_sport.roster_minimum = "3"
    bad_sport.roster_maximum = "10"
    assert bad_sport.valid?
  end
end
