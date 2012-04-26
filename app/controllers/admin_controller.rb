class AdminController < ApplicationController
  if $g_im_online && $g_ct_online
    layout "fluid-admin-green"
  elsif $g_im_online && $g_rt_online
    layout "fluid-admin-green"
  elsif $g_im_online
    layout "fluid-admin-blue"
  elsif $g_ct_online
    layout "fluid-admin-red"
  elsif $g_rt_online
    layout "fluid-admin-gray"  
  else
    layout "fluid-admin-green"  
  end
  
  before_filter :login_required
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location
  
  def index
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
