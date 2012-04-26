require File.dirname(__FILE__) + '/../test_helper'
require 'participant_controller'

# Re-raise errors caught by the controller.
class ParticipantController; def rescue_action(e) raise e end; end

class ParticipantControllerTest < Test::Unit::TestCase
  fixtures :participants

  def setup
    @controller = ParticipantController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = participants(:first).id
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

    assert_not_nil assigns(:participants)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:participant)
    assert assigns(:participant).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:participant)
  end

  def test_create
    num_participants = Participant.count

    post :create, :participant => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_participants + 1, Participant.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:participant)
    assert assigns(:participant).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Participant.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Participant.find(@first_id)
    }
  end
end
