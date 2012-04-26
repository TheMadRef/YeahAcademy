require File.dirname(__FILE__) + '/../test_helper'
require 'email_custom_text_controller'

# Re-raise errors caught by the controller.
class EmailCustomTextController; def rescue_action(e) raise e end; end

class EmailCustomTextControllerTest < Test::Unit::TestCase
  fixtures :email_custom_texts

  def setup
    @controller = EmailCustomTextController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = email_custom_texts(:first).id
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

    assert_not_nil assigns(:email_custom_texts)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:email_custom_text)
    assert assigns(:email_custom_text).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:email_custom_text)
  end

  def test_create
    num_email_custom_texts = EmailCustomText.count

    post :create, :email_custom_text => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_email_custom_texts + 1, EmailCustomText.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:email_custom_text)
    assert assigns(:email_custom_text).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      EmailCustomText.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      EmailCustomText.find(@first_id)
    }
  end
end
