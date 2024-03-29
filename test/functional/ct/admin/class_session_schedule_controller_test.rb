require File.dirname(__FILE__) + '/../../../test_helper'
require 'ct/admin/class_session_schedule_controller'

# Re-raise errors caught by the controller.
class Ct::Admin::ClassSessionScheduleController; def rescue_action(e) raise e end; end

class Ct::Admin::ClassSessionScheduleControllerTest < Test::Unit::TestCase
  fixtures :ct_session_schedules

  def setup
    @controller = Ct::Admin::ClassSessionScheduleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = ct_session_schedules(:first).id
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

    assert_not_nil assigns(:ct_session_schedules)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:ct_session_schedule)
    assert assigns(:ct_session_schedule).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:ct_session_schedule)
  end

  def test_create
    num_ct_session_schedules = CtSessionSchedule.count

    post :create, :ct_session_schedule => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_ct_session_schedules + 1, CtSessionSchedule.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:ct_session_schedule)
    assert assigns(:ct_session_schedule).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      CtSessionSchedule.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      CtSessionSchedule.find(@first_id)
    }
  end
end
