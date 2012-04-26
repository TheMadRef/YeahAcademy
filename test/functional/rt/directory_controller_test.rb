require File.dirname(__FILE__) + '/../../test_helper'
require 'rt/directory_controller'

# Re-raise errors caught by the controller.
class Rt::DirectoryController; def rescue_action(e) raise e end; end

class Rt::DirectoryControllerTest < Test::Unit::TestCase
  def setup
    @controller = Rt::DirectoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
