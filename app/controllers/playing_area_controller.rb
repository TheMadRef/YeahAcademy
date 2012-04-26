class PlayingAreaController < ApplicationController
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
  before_filter :verify_admin, :only => [ :destroy, :new, :edit, :new_playing_area]
  before_filter :require_id, :only => [ :new, :edit, :show]


  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @playing_area_pages, @playing_areas = paginate_collection PlayingArea.sorted_playing_area_array(0), :page => @params[:page], :per_page => 20
  end

  def show
    @playing_area = PlayingArea.find(params[:id])
  end

  def new
    @playing_area = PlayingArea.new
    @playing_area.facility = Facility.find(params[:id])
  end

  def create
    @playing_area = PlayingArea.new(params[:playing_area])
    
    # if no parent then set to zero
    if @playing_area.parent_id.nil?
      @playing_area.parent_id = 0
    end
    
    if @playing_area.save
      flash[:notice] = 'Playing Area was successfully created.'
      if session[:add_team_after_area]
        redirect_to :controller => '/rt/admin/team', :action => 'new', :id => session[:add_team_after_area]
        session[:add_team_after_area] = nil
      elsif session[:add_game_after_area]
        redirect_to :controller => '/rt/admin/game', :action => 'new', :id => session[:add_game_after_area]
        session[:add_game_after_area] = nil
      elsif session[:add_game_block_after_area]
        redirect_to :controller => '/rt/admin/game', :action => 'new_block', :id => session[:add_game_block_after_area]
        session[:add_game_after_area] = nil
      else
        redirect_to :action => 'list'
      end
    else
      render :action => 'new'
    end
  end

  def edit
    @playing_area = PlayingArea.find(params[:id])
  end

  def update
    @playing_area = PlayingArea.find(params[:id])
    if @playing_area.update_attributes(params[:playing_area])
      if @playing_area.parent_id.nil?
        @playing_area.parent_id = 0
      end
      @playing_area.update 
      flash[:notice] = 'PlayingArea was successfully updated.'
      redirect_to :action => 'show', :id => @playing_area
    else
      render :action => 'edit'
    end
  end

  def destroy
    #remove any sub-areas for this playing area
    sub_areas = PlayingArea.find(:all, :conditions => ["parent_id = ?", params[:id]])
    for sub_area in sub_areas
      sub_area.destroy
    end
    
    #remove the playing area
    PlayingArea.find(params[:id]).destroy
    flash[:notice] = 'Playing Area was successfully deleted.'
    redirect_to :action => 'list'
  end
end
