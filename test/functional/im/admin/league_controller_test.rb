require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/league_controller'

# Re-raise errors caught by the controller.
class Im::Admin::LeagueController; def rescue_action(e) raise e end; end

class Im::Admin::LeagueControllerTest < Test::Unit::TestCase
  fixtures :im_leagues

  def setup
    @controller = Im::Admin::LeagueController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = im_leagues(:first).id
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

    assert_not_nil assigns(:im_leagues)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:im_league)
    assert assigns(:im_league).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:im_league)
  end

  def test_create
    num_im_leagues = ImLeague.count

    post :create, :im_league => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_im_leagues + 1, ImLeague.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:im_league)
    assert assigns(:im_league).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      ImLeague.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ImLeague.find(@first_id)
    }
  end
end
