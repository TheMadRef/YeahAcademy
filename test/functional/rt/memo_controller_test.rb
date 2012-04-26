require File.dirname(__FILE__) + '/../../test_helper'
require 'rt/memo_controller'

# Re-raise errors caught by the controller.
class Rt::MemoController; def rescue_action(e) raise e end; end

class Rt::MemoControllerTest < Test::Unit::TestCase
  fixtures :rt_memos

  def setup
    @controller = Rt::MemoController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = rt_memos(:first).id
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

    assert_not_nil assigns(:rt_memos)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:rt_memo)
    assert assigns(:rt_memo).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:rt_memo)
  end

  def test_create
    num_rt_memos = RtMemo.count

    post :create, :rt_memo => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_rt_memos + 1, RtMemo.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:rt_memo)
    assert assigns(:rt_memo).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      RtMemo.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      RtMemo.find(@first_id)
    }
  end
end
