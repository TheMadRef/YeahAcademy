class Ct::Admin::TermController < ApplicationController
  layout "fluid-admin-red"

  before_filter :login_required
  # store location to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @term_pages, @terms = paginate :terms, :per_page => 10
  end

  def show
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @term = Term.find(params[:id])
    end
  end
  
  def new
    @term = Term.new
  end
  
  def new_class
    list
  end

  def create
    if params[:term].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @term = Term.new(params[:term])
      if @term.save
        flash[:notice] = 'Term was successfully created.'
        redirect_to :action => 'list'
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @term = Term.find(params[:id])
    end
  end
  
  def update
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @term = Term.find(params[:id])
      if @term.update_attributes(params[:term])
        flash[:notice] = 'Term was successfully updated.'
        redirect_to :action => 'show', :id => @term
      else
        render :action => 'edit'
      end
    end
  end
  
  def destroy
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      Term.find(params[:id]).destroy
      flash[:notice] = 'Term was successfully deleted.'
      redirect_to :action => 'list'
    end
  end
  
  def copy_term
    @term = Term.find(params[:id])    
    @term.term_name = @term.term_name + " copy"
  end

  def create_term_copy
    @term = Term.new(params[:term])
    Term.transaction do
      @term.save!
      Term.copy_term(params[:id], @term)
      flash[:notice] = "Term has been copied."
      redirect_to :action => 'list'
    end

  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "There was an error in creating the term. " + e.record.errors.full_messages.join(", ")
    render :action => 'copy_term'    
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
