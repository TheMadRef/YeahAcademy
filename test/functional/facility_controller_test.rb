require File.dirname(__FILE__) + '/../test_helper'
require 'facility_controller'

# Re-raise errors caught by the controller.
class FacilityController; def rescue_action(e) raise e end; end

class FacilityControllerTest < Test::Unit::TestCase
  fixtures :facilities

  def setup
    @controller = FacilityController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = facilities(:first).id
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

    assert_not_nil assigns(:facilities)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:facility)
    assert assigns(:facility).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:facility)
  end

  def test_create
    num_facilities = Facility.count

    post :create, :facility => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_facilities + 1, Facility.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:facility)
    assert assigns(:facility).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Facility.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Facility.find(@first_id)
    }
  end
end
