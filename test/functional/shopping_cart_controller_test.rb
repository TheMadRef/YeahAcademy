require File.dirname(__FILE__) + '/../test_helper'
require 'shopping_cart_controller'

# Re-raise errors caught by the controller.
class ShoppingCartController; def rescue_action(e) raise e end; end

class ShoppingCartControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShoppingCartController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
