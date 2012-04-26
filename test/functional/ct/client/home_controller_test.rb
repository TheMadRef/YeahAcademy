require File.dirname(__FILE__) + '/../../../test_helper'
require 'ct/client/home_controller'

# Re-raise errors caught by the controller.
class Ct::Client::HomeController; def rescue_action(e) raise e end; end

class Ct::Client::HomeControllerTest < Test::Unit::TestCase
  def setup
    @controller = Ct::Client::HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
