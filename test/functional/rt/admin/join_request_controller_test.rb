require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/admin/join_request_controller'

# Re-raise errors caught by the controller.
class Rt::Admin::JoinRequestController; def rescue_action(e) raise e end; end

class Rt::Admin::JoinRequestControllerTest < Test::Unit::TestCase
  fixtures :rt_join_requests

  def setup
    @controller = Rt::Admin::JoinRequestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rt_join_requests(:first).id
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

    assert_not_nil assigns(:rt_join_requests)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rt_join_request)
    assert assigns(:rt_join_request).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rt_join_request)
  end

  def test_create
    num_rt_join_requests = RtJoinRequest.count

    post :create, :rt_join_request => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rt_join_requests + 1, RtJoinRequest.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rt_join_request)
    assert assigns(:rt_join_request).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RtJoinRequest.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RtJoinRequest.find(@first_id)
    }
  end
end
