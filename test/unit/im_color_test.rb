require File.dirname(__FILE__) + '/../test_helper'

class ImColorTest < Test::Unit::TestCase
  fixtures :im_colors

  # Replace this with your real tests.
  def test_error_validation
    # No Color Name
    no_data = ImColor.new
    assert !no_data.valid?
    assert no_data.errors.invalid?(:color_name)

    # Invalid Data (Duplicate Color Name)
    bad_color = ImColor.new(:color_name => im_colors(:blue).color_name)
    assert !bad_color.save
    assert_equal "has already been taken" , bad_color.errors.on(:color_name)
    
    # Valid Data
    bad_color.color_name = "purple"
    assert bad_color.valid?
  end
end
