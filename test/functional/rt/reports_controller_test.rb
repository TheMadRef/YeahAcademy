require File.dirname(__FILE__) + '/../../test_helper'
require 'rt/reports_controller'

# Re-raise errors caught by the controller.
class Rt::ReportsController; def rescue_action(e) raise e end; end

class Rt::ReportsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Rt::ReportsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
