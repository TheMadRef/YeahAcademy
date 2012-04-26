require File.dirname(__FILE__) + '/../../../test_helper'
require 'ct/admin/instructor_controller'

# Re-raise errors caught by the controller.
class Ct::Admin::InstructorController; def rescue_action(e) raise e end; end

class Ct::Admin::InstructorControllerTest < Test::Unit::TestCase
  def setup
    @controller = Ct::Admin::InstructorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
