require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/client/schedule_controller'

# Re-raise errors caught by the controller.
class Rt::Client::ScheduleController; def rescue_action(e) raise e end; end

class Rt::Client::ScheduleControllerTest < Test::Unit::TestCase
  def setup
    @controller = Rt::Client::ScheduleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
