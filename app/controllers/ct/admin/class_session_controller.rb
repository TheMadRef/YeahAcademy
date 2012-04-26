class Ct::Admin::ClassSessionController < ApplicationController
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
    @ct_session_pages, @ct_sessions = paginate :ct_sessions, :include => :ct_class, :order => 'term_id DESC, class_name, s_class_name', :per_page => 10
  end

  def show
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @ct_session = CtSession.find(params[:id])
    end
  end

  def new
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @ct_session = CtSession.new
      @ct_session.ct_class = CtClass.find(params[:id])
      @ct_session.s_registration_start = @ct_session.ct_class.registration_start
      @ct_session.s_registration_end = @ct_session.ct_class.registration_end
      @ct_session.s_roster_maximum = @ct_session.ct_class.default_roster_maximum
      @ct_session.s_price = @ct_session.ct_class.default_price
      @ct_session.s_late_date = @ct_session.ct_class.default_late_date
      @ct_session.s_late_fee = @ct_session.ct_class.default_late_fee
      @ct_session.s_comment = @ct_session.ct_class.comment
      @ct_session.s_early_bird_date = @ct_session.ct_class.default_early_bird_date
      @ct_session.s_early_bird_discount = @ct_session.ct_class.default_early_bird_discount
      @ct_session.s_payment_due_date = @ct_session.ct_class.default_payment_due_date
      @ct_session.s_minimum_age = @ct_session.ct_class.default_minimum_age
      @ct_session.s_maximum_age = @ct_session.ct_class.default_maximum_age
      @categories = Category.sorted_category_array
      @categories_array = []
      for category in @categories
      	@categories_array[category] = false
      end
      @ct_instructors = CtInstructor.find(:all)
    end
  end
  
  def create
    @categories_array = []
    @categories = Category.sorted_category_array
    # Collect form data in case we have to render
    for category in @categories
      @categories_array[category] = !(params["category_#{category}"] == nil)
    end
    CtSession.transaction do
      @ct_session = CtSession.new(params[:ct_session])
      @ct_session.save!
      if !@categories[0].nil?
        for category in @categories
          if params["category_#{category}"] != nil
            ct_session_category_restriction = CtSessionCategoryRestriction.new
            ct_session_category_restriction.ct_session_id = @ct_session.id
            ct_session_category_restriction.category_id = category
            ct_session_category_restriction.save!
          end
        end
      end
      flash[:notice] = 'Class Session was successfully created.'
      redirect_to :action => 'list'
    end

  rescue ActiveRecord::RecordInvalid => e
    @ct_instructors = CtInstructor.find(:all)
    render :action => 'new'
  end

  def edit
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @categories = Category.sorted_category_array
      @ct_session = CtSession.find(params[:id])
    	@categories_array = []
	    for category in @categories
	      @categories_array[category] = CtSession.is_category_restricted?(@ct_session.id, category)
	    end
      @ct_instructors = CtInstructor.find(:all)
    end
  end
  
  def update
    @categories_array = []
    @categories = Category.sorted_category_array
    # Collect form data in case we have to render
    for category in @categories
      @categories_array[category] = !(params["category_#{category}"] == nil)
    end
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @ct_session = CtSession.find(params[:id])
      old_instructor = @ct_session.ct_instructor_id
      if !old_instructor.nil?
      	old_participant = @ct_session.ct_instructor.participant_id
  	  end
      CtSession.transaction do
      	@ct_session.update_attributes!(params[:ct_session])
        
        # Process category restrictions
	      if !@categories[0].nil?
	        for category in @categories	  
	          # check if user selected this employee title
	          if params["category_#{category}"] != nil
	            # if no existing relationship add new one
	            if !CtSession.is_category_restricted?(@ct_session.id, category)
		            ct_session_category_restriction = CtSessionCategoryRestriction.new
		            ct_session_category_restriction.ct_session_id = @ct_session.id
		            ct_session_category_restriction.category_id = category
		            ct_session_category_restriction.save!
		          end	              
	          else
	            # delete existing relationship if exist
	            if CtSession.is_category_restricted?(@ct_session.id, category)
	              CtSessionCategoryRestriction.find(:first, :conditions => ["ct_session_id = ? AND category_id = ?", @ct_session.id, category]).destroy
	            end
	          end
	        end
	      end
	      # process instructor schedule if new instructor or if it changed
	      if old_instructor != @ct_session.ct_instructor_id && !@ct_session.ct_session_schedule.nil?
	      	ct_reservations = @ct_session.ct_session_schedule.ct_reservations.find(:all)
	      	if !old_instructor.nil?
	      		for reservation in ct_reservations
	      			old_reservation = reservation.participant_events.find(:first, :conditions => ["participant_id = ?", old_participant])	
      				old_reservation.destroy
      			end
  			end
  			new_participant = CtInstructor.find_by_id(@ct_session.ct_instructor_id).participant_id
  			for reservation in ct_reservations
  				@participant_event = ParticipantEvent.new
  				@participant_event.ct_reservation = reservation
  				@participant_event.participant_id = new_participant
  				@participant_event.save!
  			end
      	  end
	      flash[:notice] = 'Class Session was successfully updated.'
        redirect_to :action => 'show', :id => @ct_session  
      end
    end
    
  rescue ActiveRecord::RecordInvalid => e
    @ct_instructors = CtInstructor.find(:all)
    render :action => 'edit'
  end
  
  def destroy
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      CtSession.find(params[:id]).destroy
      flash[:notice] = 'Class Session was successfully deleted.'
      redirect_to :action => 'list'
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
