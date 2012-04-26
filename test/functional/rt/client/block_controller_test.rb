require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/client/block_controller'

# Re-raise errors caught by the controller.
class Rt::Client::BlockController; def rescue_action(e) raise e end; end

class Rt::Client::BlockControllerTest < Test::Unit::TestCase
  def setup
    @controller = Rt::Client::BlockController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
