require File.dirname(__FILE__) + '/../test_helper'
require 'participant_custom_field_controller'

# Re-raise errors caught by the controller.
class ParticipantCustomFieldController; def rescue_action(e) raise e end; end

class ParticipantCustomFieldControllerTest < Test::Unit::TestCase
  fixtures :participant_custom_fields

  def setup
    @controller = ParticipantCustomFieldController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = participant_custom_fields(:first).id
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

    assert_not_nil assigns(:participant_custom_fields)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:participant_custom_field)
    assert assigns(:participant_custom_field).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:participant_custom_field)
  end

  def test_create
    num_participant_custom_fields = ParticipantCustomField.count

    post :create, :participant_custom_field => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_participant_custom_fields + 1, ParticipantCustomField.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:participant_custom_field)
    assert assigns(:participant_custom_field).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ParticipantCustomField.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ParticipantCustomField.find(@first_id)
    }
  end
end
