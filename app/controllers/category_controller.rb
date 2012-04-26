class CategoryController < ApplicationController
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
  before_filter :require_id, :only => [ :edit, :show]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @category_pages, @categories = paginate_collection Category.sorted_category_array, :page => @params[:page], :per_page => 20
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])

    # if no parent then set to zero
    if @category.parent_id.nil?
      @category.parent_id = 0
    end

    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      if @category.parent_id.nil?
        @category.parent_id = 0
      end
      @category.update 
      flash[:notice] = 'Category was successfully updated.'
      redirect_to :action => 'show', :id => @category
    else
      render :action => 'edit'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    categories = Category.find(:all, :conditions => ["parent_id = ?", params[:id]])
    for category in categories
    	category.destroy
    end
    flash[:notice] = 'Category was successfully deleted.'
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
