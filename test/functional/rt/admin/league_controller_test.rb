require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/admin/league_controller'

# Re-raise errors caught by the controller.
class Rt::Admin::LeagueController; def rescue_action(e) raise e end; end

class Rt::Admin::LeagueControllerTest < Test::Unit::TestCase
  def setup
    @controller = Rt::Admin::LeagueController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
