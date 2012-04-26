class Ct::Admin::SettingController < ApplicationController
  layout "fluid-admin-red"

  before_filter :login_required
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location

  def index
    show
    render :action => 'show'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
    @ct_setting = CtSetting.find(1)
  end

  def edit
    @ct_setting = CtSetting.find(1)
  end

  def update
    @ct_setting = CtSetting.find(1)
    if @ct_setting.update_attributes(params[:ct_setting])
      flash[:notice] = 'Settings were successfully updated.'
      redirect_to :action => 'show'
      set_session_variables
    else
      render :action => 'edit'
    end
  end
  
  protected

  def authorized?
    if not is_admin?
      flash[:error] = "Must be an administrator."
      return false
    else
      return true
    end
  end  
end
