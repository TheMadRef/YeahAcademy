require File.dirname(__FILE__) + '/../../../test_helper'
require 'im/admin/term_controller'

# Re-raise errors caught by the controller.
class Im::Admin::TermController; def rescue_action(e) raise e end; end

class Im::Admin::TermControllerTest < Test::Unit::TestCase
  fixtures :terms

  def setup
    @controller = Im::Admin::TermController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = terms(:first).id
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

    assert_not_nil assigns(:terms)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:term)
    assert assigns(:term).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:term)
  end

  def test_create
    num_terms = Term.count

    post :create, :term => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_terms + 1, Term.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:term)
    assert assigns(:term).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Term.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Term.find(@first_id)
    }
  end
end
