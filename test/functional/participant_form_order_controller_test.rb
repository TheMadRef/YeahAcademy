require File.dirname(__FILE__) + '/../test_helper'
require 'participant_form_order_controller'

# Re-raise errors caught by the controller.
class ParticipantFormOrderController; def rescue_action(e) raise e end; end

class ParticipantFormOrderControllerTest < Test::Unit::TestCase
  def setup
    @controller = ParticipantFormOrderController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
