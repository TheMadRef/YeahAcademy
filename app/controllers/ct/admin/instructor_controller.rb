class Ct::Admin::InstructorController < ApplicationController
  layout "fluid-client-red"

  before_filter :login_required
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location
  before_filter :require_id, :only => [:destroy, :show, :edit]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @ct_instructor_pages, @ct_instructors = paginate :ct_instructors, :per_page => 10
  end

  def create
    @ct_instructor = CtInstructor.new
    @participant_number = params[:participant_number]
    @google_account = params[:google_account]
    participant = Participant.find_by_participant_number(@participant_number)
    if participant.nil?
    	flash[:error] = 'Participant not found in database.  Please add the instructor to the participant list before assigning instructor status.' 
		list
		render :action => 'list'
    else       
    	@ct_instructor.participant = participant
    	@ct_instructor.google_account = @google_account
		if @ct_instructor.save
			flash[:notice] = 'Instructor was successfully created.'
			redirect_to :action => 'list'
		else
			flash[:error] = 'Instructor could not be added.'
			list
			render :action => 'list'
		end
	end
  end
  
  def edit
  	@ct_instructor = CtInstructor.find(params[:id])
  end
  
  def update
      @ct_instructor = CtInstructor.find(params[:id])
      if @ct_instructor.update_attributes(params[:ct_instructor])
        flash[:notice] = 'Instructor was successfully updated.'
        redirect_to :action => 'show', :id => @ct_instructor
      else
        render :action => 'edit'
      end
  end  	
  
  def destroy
    CtInstructor.find(params[:id]).destroy
    flash[:notice] = 'Instructor was successfully deleted.'
    redirect_to :action => 'list'  	
  end

  def show
	@ct_instructor = CtInstructor.find(params[:id])
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
