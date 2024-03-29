require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/admin/employee_title_controller'

# Re-raise errors caught by the controller.
class Rt::Admin::EmployeeTitleController; def rescue_action(e) raise e end; end

class Rt::Admin::EmployeeTitleControllerTest < Test::Unit::TestCase
  fixtures :rt_employee_titles

  def setup
    @controller = Rt::Admin::EmployeeTitleController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rt_employee_titles(:first).id
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

    assert_not_nil assigns(:rt_employee_titles)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rt_employee_title)
    assert assigns(:rt_employee_title).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rt_employee_title)
  end

  def test_create
    num_rt_employee_titles = RtEmployeeTitle.count

    post :create, :rt_employee_title => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rt_employee_titles + 1, RtEmployeeTitle.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rt_employee_title)
    assert assigns(:rt_employee_title).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RtEmployeeTitle.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RtEmployeeTitle.find(@first_id)
    }
  end
end
