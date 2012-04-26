class Ct::Admin::ClassController < ApplicationController
  layout "fluid-admin-red"

  before_filter :login_required
  # store loaction to user that the login screen redirects back here
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
    @ct_class_pages, @ct_classes = paginate :ct_classes, :order => "term_id, class_name", :per_page => 10
  end

  def show
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @ct_class = CtClass.find(params[:id])
      if $g_class_terms_and_conditions
	      @ct_class.ct_class_term_and_condition = CtClassTermAndCondition.find(:first, :conditions => ["ct_class_id = ?", @ct_class.id])
	      if @ct_class.ct_class_term_and_condition.nil?
	        flash[:error] = 'Roster Terms and conditions missing'
	        edit
	        render :action => 'edit'
	      end
			end
			@ct_sessions = @ct_class.ct_sessions.find(:all)
    end
  end
  
  def new
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @ct_class = CtClass.new
      if $g_class_terms_and_conditions
        @class_terms_and_conditions = CtClass.class_term_and_conditions_text(0)        
      end
      @ct_class.term = Term.find(params[:id])
      # load default registration dates from the term
      @ct_class.registration_start = @ct_class.term.default_class_registration_start
      @ct_class.registration_end = @ct_class.term.default_class_registration_end
      @ct_class.default_roster_maximum = @ct_class.term.default_class_roster_maximum
      @ct_class.default_price = @ct_class.term.default_class_price
      @ct_class.default_late_date = @ct_class.term.default_class_late_date
      @ct_class.default_late_fee = @ct_class.term.default_class_late_price
      @ct_class.default_early_bird_date = @ct_class.term.default_class_early_bird_date
      @ct_class.default_early_bird_discount = @ct_class.term.default_class_early_bird_discount
      @ct_class.default_payment_due_date = @ct_class.term.default_class_payment_due_date
      @ct_class.default_minimum_age = @ct_class.term.default_class_minimum_age
      @ct_class.default_maximum_age = @ct_class.term.default_class_maximum_age
    end
  end
    
  def new_class_session
    list
  end

  def create
    CtClass.transaction do    
      @ct_class = CtClass.new(params[:ct_class])
      if $g_class_terms_and_conditions
        @ct_class_terms_and_conditions = CtClassTermAndCondition.new
        @ct_class_terms_and_conditions.terms_and_conditions = params[:class_terms_and_conditions]        
      end
      @ct_class.save!
      if $g_class_terms_and_conditions
        @ct_class_terms_and_conditions.ct_class_id = @ct_class.id
        @ct_class_terms_and_conditions.save!
      end
      flash[:notice] = 'Class was successfully created.'
      redirect_to :action => 'list'
    end

  rescue ActiveRecord::RecordInvalid => e
    if $g_class_terms_and_conditions
      @ct_class_terms_and_conditions.valid? 
      @class_terms_and_conditions = @ct_class_terms_and_conditions.terms_and_conditions
    end
    render :action => 'new'
  end

  def edit
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @ct_class = CtClass.find(params[:id])
      if $g_class_terms_and_conditions
        @class_terms_and_conditions = CtClass.class_term_and_conditions_text(@ct_class.id)        
      end
    end
  end
  
  def update
    @ct_class = CtClass.find(params[:id])
    CtClass.transaction do
      if $g_class_terms_and_conditions
        @ct_class_terms_and_conditions = CtClassTermAndCondition.find(:first, :conditions => ["ct_class_id = ?", @ct_class.id])
        if @ct_class_terms_and_conditions.nil?          
          @ct_class_terms_and_conditions = CtClassTermAndCondition.new
          @ct_class_terms_and_conditions.ct_class_id = @ct_class.id
        end
        @ct_class_terms_and_conditions.terms_and_conditions = params[:class_terms_and_conditions]        
      end
      @ct_class.update_attributes!(params[:ct_class])
      if $g_class_terms_and_conditions
        @ct_class_terms_and_conditions.save!
      end
    end
    flash[:notice] = 'Class was successfully updated.'
    redirect_to :action => 'show', :id => @ct_class

  rescue ActiveRecord::RecordInvalid => e
    if $g_ckass_terms_and_conditions
      @ct_class_terms_and_conditions.valid? 
      @class_terms_and_conditions = @ct_class_terms_and_conditions.terms_and_conditions
    end
    render :action => 'edit'
  end
  
  def destroy
    CtClass.find(params[:id]).destroy
    flash[:notice] = 'Class was successfully deleted.'
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
