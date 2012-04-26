class Ct::Admin::ClassSessionScheduleController < ApplicationController
  layout "fluid-admin-red"

  before_filter :login_required
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location
  before_filter :require_id, :only => [ :index, :edit, :show]

  def index
		show
    render :action => 'show'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
		@ct_session = CtSession.find(params[:id])
    @ct_session_schedule = @ct_session.ct_session_schedule
    if @ct_session_schedule.nil?
    	create_ct_session_schedule(params[:id])
    end
  end

  def edit
		@ct_session = CtSession.find(params[:id])
    @ct_session_schedule = @ct_session.ct_session_schedule
    if @ct_session_schedule.nil?
    	create_ct_session_schedule(params[:id])
    end
    build_playing_area_array
  end

  def update
	@ct_session = CtSession.find(params[:id])
    @ct_session_schedule = @ct_session.ct_session_schedule
    CtSessionSchedule.transaction do
    	@ct_session_schedule.update_attributes!(params[:ct_session_schedule])
    	for date in @ct_session_schedule.session_start_date.to_date..@ct_session_schedule.session_end_date.to_date do
    		@ct_reservation = CtReservation.find(:first, :conditions => ["ct_session_schedule_id = ? AND session_date = ?", @ct_session_schedule.id, date])
    		if date.wday == 0 && @ct_session_schedule.meet_sunday || date.wday == 1 && @ct_session_schedule.meet_monday || date.wday == 2 && @ct_session_schedule.meet_tuesday || date.wday == 3 && @ct_session_schedule.meet_wednesday || date.wday == 4 && @ct_session_schedule.meet_thursday || date.wday == 5 && @ct_session_schedule.meet_friday || date.wday == 6 && @ct_session_schedule.meet_saturday
    			if @ct_reservation.nil?
    				@ct_reservation = CtReservation.new
    				@ct_reservation.ct_session_schedule_id = @ct_session_schedule.id
    				@ct_reservation.session_date = date
    			end
    			@ct_reservation.playing_area_id = @ct_session_schedule.playing_area_id
  				if date.wday == 0
    				@ct_reservation.start_time = @ct_session_schedule.sunday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.sunday_end_time
    			elsif date.wday == 1	 
    				@ct_reservation.start_time = @ct_session_schedule.monday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.monday_end_time
    			elsif date.wday == 2	 
    				@ct_reservation.start_time = @ct_session_schedule.tuesday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.tuesday_end_time
    			elsif date.wday == 3	 
    				@ct_reservation.start_time = @ct_session_schedule.wednesday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.wednesday_end_time
    			elsif date.wday == 4	 
    				@ct_reservation.start_time = @ct_session_schedule.thursday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.thursday_end_time
    			elsif date.wday == 5	 
    				@ct_reservation.start_time = @ct_session_schedule.friday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.friday_end_time
    			elsif date.wday == 6
    				@ct_reservation.start_time = @ct_session_schedule.saturday_start_time
    				@ct_reservation.end_time = @ct_session_schedule.saturday_end_time
    			end
    			@ct_reservation.save!
    			if !@ct_session.ct_instructor.nil?
    				@participant_event = ParticipantEvent.find(:first, :conditions => ["ct_reservation_id = ? AND participant_id = ?", @ct_reservation.id, @ct_session.ct_instructor.participant_id])
    				if @participant_event.nil?
    					@participant_event = ParticipantEvent.new
    					@participant_event.ct_reservation = @ct_reservation
    					@participant_event.participant_id = @ct_session.ct_instructor.participant_id
    				end
    				@participant_event.save!
    			end
    		else
    			if !@ct_reservation.nil?
    				@ct_reservation.destroy
    			end 		
    		end
    	end
      	flash[:notice] = 'CtSessionSchedule was successfully updated.'
      	redirect_to :action => 'show', :id => @ct_session
    end
  rescue ActiveRecord::RecordInvalid => e
    build_playing_area_array
    render :action => 'edit'
  end

  def destroy
    CtSessionSchedule.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

protected

	def create_ct_session_schedule(id)
		@ct_session_schedule = CtSessionSchedule.new
		@ct_session_schedule.session_start_date = Date.today
		@ct_session_schedule.session_end_date = Date.today + 1
		@ct_session_schedule.ct_session_id = id
		@ct_session_schedule.save
	end
end
