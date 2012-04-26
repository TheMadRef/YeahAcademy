class EmailCustomTextController < ApplicationController
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
    show
    render :action => 'show'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :update ],
         :redirect_to => { :action => :list }

  def show
    @email_custom_text = EmailCustomText.find(1)
    if @email_custom_text.nil?
    	@email_custom_text = EmailCustomText.new
    	@email_custom_text.save
    end
  end

  def edit
    @email_custom_text = EmailCustomText.find(1)
  end

  def update
    @email_custom_text = EmailCustomText.find(1)
    if @email_custom_text.update_attributes(params[:email_custom_text])
      flash[:notice] = 'EmailCustomText was successfully updated.'
      redirect_to :action => 'show', :id => @email_custom_text
    else
      render :action => 'edit'
    end
  end

end
