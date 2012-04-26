require File.dirname(__FILE__) + '/../../test_helper'
require 'ct/roster_controller'

# Re-raise errors caught by the controller.
class Ct::RosterController; def rescue_action(e) raise e end; end

class Ct::RosterControllerTest < Test::Unit::TestCase
  def setup
    @controller = Ct::RosterController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
