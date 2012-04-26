require File.dirname(__FILE__) + '/../../../test_helper'
require 'ct/admin/setting_controller'

# Re-raise errors caught by the controller.
class Ct::Admin::SettingController; def rescue_action(e) raise e end; end

class Ct::Admin::SettingControllerTest < Test::Unit::TestCase
  fixtures :ct_settings

  def setup
    @controller = Ct::Admin::SettingController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = ct_settings(:first).id
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

    assert_not_nil assigns(:ct_settings)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:ct_setting)
    assert assigns(:ct_setting).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:ct_setting)
  end

  def test_create
    num_ct_settings = CtSetting.count

    post :create, :ct_setting => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_ct_settings + 1, CtSetting.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:ct_setting)
    assert assigns(:ct_setting).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      CtSetting.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      CtSetting.find(@first_id)
    }
  end
end
