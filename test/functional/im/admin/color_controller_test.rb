require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/color_controller'

# Re-raise errors caught by the controller.
class Im::Admin::ColorController; def rescue_action(e) raise e end; end

class Im::Admin::ColorControllerTest < Test::Unit::TestCase
  fixtures :im_colors

  def setup
    @controller = Im::Admin::ColorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = im_colors(:first).id
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

    assert_not_nil assigns(:im_colors)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:im_color)
    assert assigns(:im_color).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:im_color)
  end

  def test_create
    num_im_colors = ImColor.count

    post :create, :im_color => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_im_colors + 1, ImColor.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:im_color)
    assert assigns(:im_color).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ImColor.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ImColor.find(@first_id)
    }
  end
end
