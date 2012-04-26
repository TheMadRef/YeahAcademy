require File.dirname(__FILE__) + '/../test_helper'
require 'payment_setting_controller'

# Re-raise errors caught by the controller.
class PaymentSettingController; def rescue_action(e) raise e end; end

class PaymentSettingControllerTest < Test::Unit::TestCase
  fixtures :payment_settings

  def setup
    @controller = PaymentSettingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = payment_settings(:first).id
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

    assert_not_nil assigns(:payment_settings)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:payment_setting)
    assert assigns(:payment_setting).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:payment_setting)
  end

  def test_create
    num_payment_settings = PaymentSetting.count

    post :create, :payment_setting => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_payment_settings + 1, PaymentSetting.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:payment_setting)
    assert assigns(:payment_setting).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PaymentSetting.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PaymentSetting.find(@first_id)
    }
  end
end
