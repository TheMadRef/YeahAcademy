class FacilityController < ApplicationController
  if $g_im_online && $g_ct_online
    layout "fluid-client-green"
  elsif $g_im_online && $g_rt_online
    layout "fluid-client-green"
  elsif $g_im_online
    layout "fluid-client-blue"
  elsif $g_ct_online
    layout "fluid-client-red"
  elsif $g_rt_online
    layout "fluid-client-gray"  
  else
    layout "fluid-client-green"  
  end

  before_filter :login_required
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location

  before_filter :require_id, :only => [:edit, :show]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @facility_pages, @facilities = paginate :facilities, :per_page => 15, :order => 'facility_name'
  end

  def new_playing_area
    list
  end

  def show
    @facility = Facility.find(params[:id])
  end

  def new
    @facility = Facility.new
  end

  def create
    @facility = Facility.new(params[:facility])
    if @facility.save
      flash[:notice] = 'Facility was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @facility = Facility.find(params[:id])
  end

  def update
    @facility = Facility.find(params[:id])
    if @facility.update_attributes(params[:facility])
      flash[:notice] = 'Facility was successfully updated.'
      redirect_to :action => 'show', :id => @facility
    else
      render :action => 'edit'
    end
  end

  def destroy
    Facility.find(params[:id]).destroy
    flash[:notice] = 'Facility was successfully deleted.'
    redirect_to :action => 'list'
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
