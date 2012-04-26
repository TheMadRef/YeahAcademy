require File.dirname(__FILE__) + '/../test_helper'
require 'playing_area_controller'

# Re-raise errors caught by the controller.
class PlayingAreaController; def rescue_action(e) raise e end; end

class PlayingAreaControllerTest < Test::Unit::TestCase
  fixtures :playing_areas

  def setup
    @controller = PlayingAreaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = playing_areas(:first).id
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

    assert_not_nil assigns(:playing_areas)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:playing_area)
    assert assigns(:playing_area).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:playing_area)
  end

  def test_create
    num_playing_areas = PlayingArea.count

    post :create, :playing_area => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_playing_areas + 1, PlayingArea.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:playing_area)
    assert assigns(:playing_area).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PlayingArea.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PlayingArea.find(@first_id)
    }
  end
end
