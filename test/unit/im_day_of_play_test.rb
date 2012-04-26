require File.dirname(__FILE__) + '/../test_helper'

class ImDayOfPlayTest < Test::Unit::TestCase
  fixtures :im_day_of_plays

  def test_error_validation
    # Testing not including valid data
    no_data = ImDayOfPlay.new
    assert !no_data.save
    assert no_data.errors.invalid?(:im_sport_id)
    assert no_data.errors.invalid?(:dop_name)

    # Invalid Data (Duplicate Day of Play Name)
    bad_dop = ImDayOfPlay.new(:dop_name => im_day_of_plays(:monday).dop_name,
    :im_sport_id => im_day_of_plays(:monday).im_sport_id)
    assert !bad_dop.save
    assert_equal "has already been taken" , bad_dop.errors.on(:dop_name)
    
    # Valid Data
    bad_dop.dop_name = "Wednesday"
    assert bad_dop.valid?
  end
end
