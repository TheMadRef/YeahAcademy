require File.dirname(__FILE__) + '/../../../test_helper'
require 'rt/client/out_date_controller'

# Re-raise errors caught by the controller.
class Rt::Client::OutDateController; def rescue_action(e) raise e end; end

class Rt::Client::OutDateControllerTest < Test::Unit::TestCase
  fixtures :rt_participant_out_dates

  def setup
    @controller = Rt::Client::OutDateController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rt_participant_out_dates(:first).id
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

    assert_not_nil assigns(:rt_participant_out_dates)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rt_participant_out_date)
    assert assigns(:rt_participant_out_date).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rt_participant_out_date)
  end

  def test_create
    num_rt_participant_out_dates = RtParticipantOutDate.count

    post :create, :rt_participant_out_date => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rt_participant_out_dates + 1, RtParticipantOutDate.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rt_participant_out_date)
    assert assigns(:rt_participant_out_date).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RtParticipantOutDate.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RtParticipantOutDate.find(@first_id)
    }
  end
end
