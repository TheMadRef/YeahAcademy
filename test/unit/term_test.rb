require File.dirname(__FILE__) + '/../test_helper'

class TermTest < Test::Unit::TestCase
  fixtures :terms

  # Replace this with your real tests.
  def test_error_validation
    # No Term Name
    no_data = Term.new
    assert !no_data.valid?
    assert no_data.errors.invalid?(:term_name)

    # Invalid Data (Duplicate Term Name, Invalid Dates)
    bad_term = Term.new(:term_name => terms(:test_term).term_name,
    :default_class_registration_start => "01-01-2001",
    :default_class_registration_end => "01-01-2000" )
    assert !bad_term.save
    assert_equal "has already been taken" , bad_term.errors.on(:term_name)
    assert_equal "should be greater than Start Date" , bad_term.errors.on(:default_class_registration_end)
    
    # Valid Data
    good_term = Term.new(:term_name => "Fall 2000",
    :default_class_registration_start => "01-01-2001",
    :default_class_registration_end => "01-01-2002" )
    assert good_term.valid?
  end
end
