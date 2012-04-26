require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/admin/term_controller'

# Re-raise errors caught by the controller.
class Rt::Admin::TermController; def rescue_action(e) raise e end; end

class Rt::Admin::TermControllerTest < Test::Unit::TestCase
  def setup
    @controller = Rt::Admin::TermController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
