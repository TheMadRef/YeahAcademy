require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/division_controller'

# Re-raise errors caught by the controller.
class Im::Admin::DivisionController; def rescue_action(e) raise e end; end

class Im::Admin::DivisionControllerTest < Test::Unit::TestCase
  fixtures :im_divisions

  def setup
    @controller = Im::Admin::DivisionController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = im_divisions(:first).id
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

    assert_not_nil assigns(:im_divisions)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:im_division)
    assert assigns(:im_division).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:im_division)
  end

  def test_create
    num_im_divisions = ImDivision.count

    post :create, :im_division => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_im_divisions + 1, ImDivision.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:im_division)
    assert assigns(:im_division).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ImDivision.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ImDivision.find(@first_id)
    }
  end
end
