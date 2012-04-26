require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/dop_controller'

# Re-raise errors caught by the controller.
class Im::Admin::DopController; def rescue_action(e) raise e end; end

class Im::Admin::DopControllerTest < Test::Unit::TestCase
  fixtures :im_day_of_plays

  def setup
    @controller = Im::Admin::DopController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = im_day_of_plays(:first).id
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

    assert_not_nil assigns(:im_day_of_plays)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:im_day_of_play)
    assert assigns(:im_day_of_play).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:im_day_of_play)
  end

  def test_create
    num_im_day_of_plays = ImDayOfPlay.count

    post :create, :im_day_of_play => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_im_day_of_plays + 1, ImDayOfPlay.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:im_day_of_play)
    assert assigns(:im_day_of_play).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ImDayOfPlay.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ImDayOfPlay.find(@first_id)
    }
  end
end
