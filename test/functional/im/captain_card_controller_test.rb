require File.dirname(__FILE__) + '/../../test_helper'
require 'im/captain_card_controller'

# Re-raise errors caught by the controller.
class Im::CaptainCardController; def rescue_action(e) raise e end; end

class Im::CaptainCardControllerTest < Test::Unit::TestCase
  fixtures :im_captain_cards

  def setup
    @controller = Im::CaptainCardController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = im_captain_cards(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:im_captain_cards)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:im_captain_card)
    assert assigns(:im_captain_card).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:im_captain_card)
  end

  def test_create
    num_im_captain_cards = ImCaptainCard.count

    post :create, :im_captain_card => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_im_captain_cards + 1, ImCaptainCard.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:im_captain_card)
    assert assigns(:im_captain_card).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ImCaptainCard.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ImCaptainCard.find(@first_id)
    }
  end
end
