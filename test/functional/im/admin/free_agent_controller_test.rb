require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/free_agent_controller'

# Re-raise errors caught by the controller.
class Im::Admin::FreeAgentController; def rescue_action(e) raise e end; end

class Im::Admin::FreeAgentControllerTest < Test::Unit::TestCase
  def setup
    @controller = Im::Admin::FreeAgentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
