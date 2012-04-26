require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/term_and_condition_controller'

# Re-raise errors caught by the controller.
class Im::Admin::TermAndConditionController; def rescue_action(e) raise e end; end

class Im::Admin::TermAndConditionControllerTest < Test::Unit::TestCase
  def setup
    @controller = Im::Admin::TermAndConditionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
