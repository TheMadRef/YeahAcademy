require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/admin/user_group_controller'

# Re-raise errors caught by the controller.
class Rt::Admin::UserGroupController; def rescue_action(e) raise e end; end

class Rt::Admin::UserGroupControllerTest < Test::Unit::TestCase
  fixtures :rt_user_groups

  def setup
    @controller = Rt::Admin::UserGroupController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rt_user_groups(:first).id
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

    assert_not_nil assigns(:rt_user_groups)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rt_user_group)
    assert assigns(:rt_user_group).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rt_user_group)
  end

  def test_create
    num_rt_user_groups = RtUserGroup.count

    post :create, :rt_user_group => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rt_user_groups + 1, RtUserGroup.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rt_user_group)
    assert assigns(:rt_user_group).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RtUserGroup.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RtUserGroup.find(@first_id)
    }
  end
end
