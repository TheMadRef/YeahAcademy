class Ct::RosterController < ApplicationController
  layout "fluid-client-red"

  before_filter :login_required
  before_filter :require_id, :only => [:list, :email_roster, :join_class, :approve, :admin_pay, :instructor_pay, :destroy, :email_session_roster, :send_email_to_roster]
  before_filter :verify_admin, :only => [:list, :create, :approve, :admin_pay]
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location

  def index
    my_classes
    render :action => 'my_classes'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :email_roster ],
         :redirect_to => { :action => :list }

  def my_classes
    @my_classes = CtRoster.find(:all, :select =>"ct_rosters.*", :joins => "INNER JOIN participants ON ct_rosters.participant_id = participants.id", :conditions => ["ct_rosters.participant_id = ? OR participants.parent_id = ?", current_user.participant_id, current_user.participant_id])
  end

  def list
	@ct_roster = CtRoster.new
	@ct_roster.ct_session = CtSession.find(params[:id])
	create_pagination
  end

  def my_assignments
	@ct_session_pages, @ct_sessions = paginate :ct_sessions, :order => "ct_class_id ASC, s_registration_end ASC", :conditions => ["ct_instructor_id = ?", current_user.participant.ct_instructor.id], :per_page => 10
  end
  
  def instructor_roster
  	@ct_session = CtSession.find(params[:id])
  	if @ct_session.ct_instructor.participant_id == current_user.participant_id
  		@ct_roster_pages, @ct_rosters = paginate :ct_rosters, :conditions => ['ct_session_id = ?', @ct_session.id], :per_page => 10
  	else
  		flash[:error] = "Unauthorized"
  		redirect_to :controller => '/home', :action => 'index'
  	end
  end

	def email_roster
	  ct_session = CtSession.find(params[:id])
	  ct_rosters = ct_session.ct_rosters.find(:all)
	  participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number', :conditions => ["show_on_reports = ?", true])		
	  email = CtRosterMailer.create_email_roster(params[:email_address], ct_rosters, ct_session.ct_class.class_name, ct_session.s_class_name, participant_fields)
	  begin
	    CtRosterMailer.deliver(email)
	    flash[:notice] = "Email Sent Successfully"
	  rescue
	  	flash[:error] = "A problem prevented this email from being sent"
	  end
	  redirect_to :action => 'list', :id => params[:id]
	end
	
	def email_session_roster
		@ct_session = CtSession.find(params[:id])
	end

	def send_email_to_roster
		ct_session = CtSession.find(params[:id])
		ct_rosters = ct_session.ct_rosters.find(:all)
		for roster in ct_rosters
	      email = CtRosterMailer.create_email_session_roster(roster.participant.first_name, roster.participant.last_name, roster.participant.email, params[:subject], params[:body])
	      email_error = false
	      email_error_text = "Problem Sending Emails."
      	  begin
		    CtRosterMailer.deliver(email)			
		  rescue Exception => e
	    	email_error = true
	    	email_error_text = email_error_text + " Email to " + roster.participant.first_name + " " + roster.participant.last_name + " caused " + e + "."
	      end
		end
		if email_error
			flash[:error] = email_error_text
		end
		if is_admin?
			redirect_to :action => 'list', :id => params[:id]
		else
			redirect_to :action => 'instructor_roster', :id => params[:id]
		end
	end

  def join_class
    if $g_master_ct_terms_and_conditions && !current_user.participant.ct_terms_and_conditions
      session[:add_class_after_update] = params[:id]
      flash[:error] = "Please accept Terms and Conditions to sign up for classes.  Scroll to the bottom of this page – accept all Terms."
      redirect_to :controller => '/account', :action => 'my_account'
    else
    	@ct_roster = CtRoster.new
    	@ct_roster.ct_session_id = params[:id]
    	@ct_session = CtSession.find_by_id(params[:id])
    	@skip_form = false
    	@family_members = Participant.find(:all, :conditions => ["parent_id = ?", current_user.participant_id])
    	if @ct_session.s_registration_end < Time.now || @ct_session.s_registration_start > Time.now
      	flash[:error] = "Class is currently closed for registration."
      	redirect_to :controller => '/ct/client', :action => 'class_list'
    	else
      	@ct_all_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_registration_end > ?", Time.now, Time.now])
      	if $g_class_terms_and_conditions
      	  class_terms_and_conditions = CtClassTermAndCondition.find(:first, :conditions => ["ct_class_id = ?", @ct_session.ct_class_id])
      	  if class_terms_and_conditions.nil?
      	    @skip_form = true
      	  else
      	    @terms_and_conditions = class_terms_and_conditions.terms_and_conditions
      	  end
      	end
  			restricted_categories = @ct_session.ct_session_category_restrictions.find(:all)
  			if restricted_categories[0].nil?
  				@class_family_members = Participant.find(:all, :conditions => ["parent_id = ? OR id = ?", current_user.participant_id, current_user.participant_id])				
  			else
  				conditions = "(category_id = " + restricted_categories.collect{|u| u.category_id}.join(" OR category_id = ") + ")"
  				@class_family_members = Participant.find(:all, :conditions => ["(parent_id = ? OR id = ?) AND NOT " + conditions, current_user.participant_id, current_user.participant_id])
  			end
    	end  
    end
  end

  def create
	  CtRoster.transaction do
	    @ct_roster = CtRoster.new(params[:ct_roster])
	    @participant_number = params[:participant_number]
	    @ct_roster.participant = Participant.find_by_participant_number(@participant_number)        
	    @line_item = LineItem.new
	    if Time.now > @ct_roster.ct_session.s_late_date
	      session_price = @ct_roster.ct_session.s_price + @ct_roster.ct_session.s_late_fee
	      @line_item.comment = "Price includes a $" + sprintf("%.2f", @ct_roster.ct_session.s_late_fee.to_s) + " late fee."
				elsif Time.now < @ct_roster.ct_session.s_early_bird_date
	      session_price = @ct_roster.ct_session.s_price - @ct_roster.ct_session.s_early_bird_discount					
	      @line_item.comment = "Price includes a $" + sprintf("%.2f", @ct_roster.ct_session.s_early_bird_discount.to_s) + " early bird discount."
	    else
	      session_price = @ct_roster.ct_session.s_price
	    end
				if $g_set_number_of_days_to_pay
					@line_item.payment_due_date = Time.now + ($g_number_of_days_to_pay * 60 * 60 * 24)
				else
					@line_item.payment_due_date = @ct_roster.ct_session.s_payment_due_date
				end
	    @line_item.payment_item_id = 3
	    @line_item.price = session_price
	    if @ct_roster.participant.nil? || @ct_roster.participant.participant.nil?
		    @line_item.participant = @ct_roster.participant
		else
			@line_item.participant_id = @ct_roster.participant.parent_id
		end
	    if @ct_roster.ct_session.s_price > 0
	      @ct_roster.paid = false
	    end
	    @ct_roster.approved = false
	    
	    # if bundle session
	    if @ct_roster.ct_session.s_all_bundle
	      # find all sessions for the class
	      all_sessions = CtSession.find(:all, :conditions => ["ct_class_id = ?", @ct_roster.ct_session.ct_class_id])
	      # start a transaction
	      # loop trough the session
	      for ct_session in all_sessions
	        # create new roster and load info then save
	        @roster = CtRoster.new
	        @roster.participant = @ct_roster.participant
	        @roster.ct_session = ct_session
	        @roster.approved = @ct_roster.approved
	        if @ct_roster.ct_session.s_price > 0 && @ct_roster.ct_session_id == ct_session.id
	          @roster.paid = false
	          @roster.save!
	          @line_item.ct_roster_id = @roster.id
	        else
	          @roster.save!            
	        end
	        reservations = ct_session.ct_reservations.find(:all)
	        for reservation in reservations
	        	@participant_event = ParticipantEvent.new
	        	@participant_event.participant = @roster.participant
	        	@participant_event.ct_session = ct_session
	        	@participant_event.save!
	        end
	      end
	    # just one session so save
	    else
	      @ct_roster.save!
	      @line_item.ct_roster = @ct_roster
	      if !@ct_roster.ct_session.ct_session_schedule.nil?
		      reservations = @ct_roster.ct_session.ct_session_schedule.ct_reservations.find(:all)
			  for reservation in reservations
		      	@participant_event = ParticipantEvent.new
		      	@participant_event.participant = @ct_roster.participant
		      	@participant_event.ct_reservation_id = reservation.id
		      	@participant_event.save!
		      end
		  end
	    end
	    if @ct_roster.ct_session.s_price > 0
	      @line_item.save!
	    end 
	    # tell user and go back to list
	    flash[:notice] = 'Participant added to Roster.'
	    redirect_to :action => 'list', :id => @ct_roster.ct_session
	  end 
  
  rescue ActiveRecord::RecordInvalid => e
    create_pagination
    render :action => 'list'
  end  

  def process_join_class
    CtRoster.transaction do
      @ct_roster = CtRoster.new(params[:ct_roster])
	    @ct_roster.approved = false
      if @ct_roster.terms_and_conditions
        @ct_roster.terms_and_conditions_timestamp = Time.now
      end
      if Time.now > @ct_roster.ct_session.s_late_date
        session_price = @ct_roster.ct_session.s_price + @ct_roster.ct_session.s_late_fee
      else
        session_price = @ct_roster.ct_session.s_price
      end
      @line_item = LineItem.new
      if Time.now > @ct_roster.ct_session.s_late_date
        session_price = @ct_roster.ct_session.s_price + @ct_roster.ct_session.s_late_fee
        @line_item.comment = "Price includes a $" + sprintf("%.2f", @ct_roster.ct_session.s_late_fee.to_s) + " late fee."
			elsif Time.now < @ct_roster.ct_session.s_early_bird_date
        session_price = @ct_roster.ct_session.s_price - @ct_roster.ct_session.s_early_bird_discount					
        @line_item.comment = "Price includes a $" + sprintf("%.2f", @ct_roster.ct_session.s_early_bird_discount.to_s) + " early bird discount."
      else
        session_price = @ct_roster.ct_session.s_price
      end
			if $g_set_number_of_days_to_pay
				@line_item.payment_due_date = Time.now + ($g_number_of_days_to_pay * 60 * 60 * 24)
			else
				@line_item.payment_due_date = @ct_roster.ct_session.s_payment_due_date
			end
      @line_item.payment_item_id = 3
      @line_item.price = session_price
      @line_item.participant = current_user.participant
      if @ct_roster.ct_session.s_price > 0
        @ct_roster.paid = false
      end
      @ct_roster.approved = false
      
      # if bundle session
      if @ct_roster.ct_session.s_all_bundle
        # find all sessions for the class
        all_sessions = CtSession.find(:all, :conditions => ["ct_class_id = ?", @ct_roster.ct_session.ct_class_id])
        # start a transaction
        # loop trough the session
        for ct_session in all_sessions
          # create new roster and load info then save
          @roster = CtRoster.new
          @roster.participant = current_user.participant
          @roster.ct_session = ct_session
          @roster.approved = @ct_roster.approved
          if @ct_roster.ct_session.s_price > 0 && @ct_roster.ct_session_id == ct_session.id
            @roster.paid = false
            @roster.save!
            @line_item.ct_roster_id = @roster.id
          else
            @roster.save!            
          end
          reservations = ct_session.ct_reservations.find(:all)
          for reservation in reservations
        	@participant_event = ParticipantEvent.new
        	@participant_event.participant = @roster.participant
        	@participant_event.ct_session = ct_session
          	@participant_event.save!
          end
        end
        # just one session so save
      else
        @ct_roster.save!
        @line_item.ct_roster = @ct_roster
	      if !@ct_roster.ct_session.ct_session_schedule.nil?
		      reservations = @ct_roster.ct_session.ct_session_schedule.ct_reservations.find(:all)
			  for reservation in reservations
		      	@participant_event = ParticipantEvent.new
		      	@participant_event.participant = @ct_roster.participant
		      	@participant_event.ct_reservation_id = reservation.id
		      	@participant_event.save!
		      end
		  end
      end
      if @ct_roster.ct_session.s_price > 0
        @line_item.save!
      end 

      # tell user and go back to list
      flash[:notice] = 'You have been signed up for the class'
      redirect_to :action => 'my_classes', :id => @ct_roster.ct_session
    end
  
  rescue ActiveRecord::RecordInvalid => e
    @ct_session = CtSession.find_by_id(@ct_roster.ct_session_id)
    @skip_form = false
    if @ct_session.s_registration_end < Time.now || @ct_session.s_registration_start > Time.now
      flash[:error] = "Class is currently closed for registration."
      redirect_to :controller => '/ct/client', :action => 'class_list'
    else
	@ct_all_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_registration_end > ?", Time.now, Time.now])
      if $g_class_terms_and_conditions
        class_terms_and_conditions = CtClassTermAndCondition.find(:first, :conditions => ["ct_class_id = ?", @ct_session.ct_class_id])
        if class_terms_and_conditions.nil?
          @skip_form = true
        else
          @terms_and_conditions = class_terms_and_conditions.terms_and_conditions
        end
      end
    end
		restricted_categories = @ct_session.ct_session_category_restrictions.find(:all)
		if restricted_categories[0].nil?
			@class_family_members = Participant.find(:all, :conditions => ["parent_id = ? OR id = ?", current_user.participant_id, current_user.participant_id])				
		else
			conditions = "(category_id = " + restricted_categories.collect{|u| u.category_id}.join(" OR category_id = ") + ")"
			@class_family_members = Participant.find(:all, :conditions => ["(parent_id = ? OR id = ?) AND NOT " + conditions, current_user.participant_id, current_user.participant_id])
		end
		@family_members = Participant.find(:all, :conditions => ["parent_id = ?", current_user.participant_id])
    render :action => 'join_class', :id => @ct_roster.ct_session_id
  end

  def approve
	ct_roster = CtRoster.find(params[:id])
	ct_roster.approved = true
	
	# if bundle session
	if ct_roster.ct_session.s_all_bundle
	# find all sessions for the class
	all_sessions = CtSession.find(:all, :conditions => ["ct_class_id = ?", ct_roster.ct_session.ct_class_id])
	# start a transaction
	CtRoster.transaction do
	  # loop trough the session
	  for ct_session in all_sessions
	    # find roster and load info then save
	    roster = CtRoster.find(:first, :conditions => ['ct_session_id = ? AND participant_id = ?', ct_session.id, ct_roster.participant.id])
	    if !roster.nil? 
	      roster.approved = ct_roster.approved
	      roster.save!
	    end
	  end
	end
	# just one session so save
	else
	ct_roster.save!
	end
	flash[:notice] = 'Participant approved.'
	redirect_to :action => 'list', :id => ct_roster.ct_session_id

  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = 'Participant could not be approved.'
    redirect_to :action => 'list', :id => ct_roster.ct_session_id
  end

  def admin_pay
	ct_roster = CtRoster.find(params[:id])
	if ct_roster.paid
		flash[:warning] = 'Payment already made for this participant'
		redirect_to :action => 'list', :id => ct_roster.ct_session_id
	else
		CtRoster.transaction do
		  # if bundle session
		  order = Order.new
		  order.payment_type_id = 1
		  line_item = LineItem.find(:first, :conditions => ["ct_roster_id = ?", ct_roster.id])
		  order.participant_id = line_item.participant_id
		  order.completed = true
		  order.save!
		  line_item.order_id = order.id
		  line_item.save!
		  approve_order(order.id)
		  flash[:notice] = 'Payment approved.'
		  redirect_to :action => 'list', :id => ct_roster.ct_session_id
		end
	end

  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = "Payment could not be approved." + e.record.errors.full_messages.join(", ")
    redirect_to :action => 'list', :id => ct_roster.ct_session_id
  end

  def instructor_pay
	ct_roster = CtRoster.find(params[:id])
	if ct_roster.ct_session.ct_instructor.participant_id != current_user.participant_id
		flash[:error] = "Unauthorized"
		redirect_to :controller => '/home'
	else
		if ct_roster.paid
			flash[:warning] = 'Payment already made for this participant'
			redirect_to :action => 'list', :id => ct_roster.ct_session_id
		else
			CtRoster.transaction do
			  # if bundle session
			  order = Order.new
			  order.payment_type_id = 8
			  line_item = LineItem.find(:first, :conditions => ["ct_roster_id = ?", ct_roster.id])
			  order.participant_id = line_item.participant_id
			  order.completed = true
			  order.save!
			  line_item.order_id = order.id
			  line_item.save!
			  approve_order(order.id)
			  flash[:notice] = 'Payment approved.'
			  redirect_to :action => 'instructor_roster', :id => ct_roster.ct_session_id
			end
		end
	end
	
  rescue ActiveRecord::RecordInvalid => e
    flash[:error] = 'Payment could not be approved.'
    redirect_to :action => 'list', :id => ct_roster.ct_session_id
  end

  def destroy
    # find roster record
    ct_roster = CtRoster.find(params[:id])
    if !(is_admin? || (ct_roster.participant_id == current_user.participant_id || ct_roster.participant.parent_id == current_user.participant_id)) || (ct_roster.ct_session.ct_instructor.participant_id == current_user.participant_id)
      redirect_to :controller => '/home', :action => 'index'
    else
      #save session id for redirect
      ct_session = ct_roster.ct_session
  
      #remove payment line item if not yet paid
      line_item = LineItem.find(:first, :conditions => ["ct_roster_id = ?", ct_roster.id])
      if !line_item.nil?
        if line_item.order_id.nil?
          line_item.destroy
        else
        	line_item.ct_roster = nil
        end
      end
      
      # start a transaction
      CtRoster.transaction do
	      # if bundle session
	      if ct_roster.ct_session.s_all_bundle
	        # find all sessions for the class
	        all_sessions = CtSession.find(:all, :conditions => ["ct_class_id = ?", ct_roster.ct_session.ct_class_id])
	          # loop trough the session
	          for ct_session in all_sessions
	            # find roster and destroy
	            roster = CtRoster.find(:first, :conditions => ['ct_session_id = ? AND participant_id = ?', ct_session.id, ct_roster.participant.id])
	            if !roster.nil? 
			      #remove reservations from system
			      ct_schedule = CtSessionSchedule.find(:first, :conditions => ["ct_session_id = ?", roster.ct_session_id])
			      if !ct_schedule.nil?
				      ct_reservations = ct_schedule.ct_reservations.find(:all)
				      for reservation in ct_reservations
				      	event = ParticipantEvent.find(:first, :conditions => ["participant_id = ? AND ct_reservation_id = ?", roster.participant_id, reservation.id])
				      	if !event.nil?
				      		event.destroy
			      		end
		      	  	  end
		      	  end	
		      	  roster.destroy
	            end
	          end
	      # just one session so destroy
	      else
		    #remove reservations from system
		    ct_schedule = CtSessionSchedule.find(:first, :conditions => ["ct_session_id = ?", ct_roster.ct_session_id])
		    if !ct_schedule.nil?
			    ct_reservations = ct_schedule.ct_reservations.find(:all)
			    for reservation in ct_reservations
			      	event = ParticipantEvent.find(:first, :conditions => ["participant_id = ? AND ct_reservation_id = ?", ct_roster.participant_id, reservation.id])
			      	if !event.nil?
			      		event.destroy
		      		end
	      	  	end
	      	end	
	        ct_roster.destroy
	      end
	  end
      flash[:notice] = 'Participant removed from Roster.'
      if is_admin?
        redirect_to :action => 'list', :id => ct_session
      elsif CtSession.find(ct_session).ct_instructor.participant_id == current_user.participant_id
      	redirect_to :action => 'instructor_roster', :id => ct_session
      else
        redirect_to :action => 'my_classes'
      end
    end
  end
  
  protected
  
  def create_pagination
    @ct_roster_pages, @ct_rosters = paginate :ct_rosters, :conditions => ['ct_session_id = ?', @ct_roster.ct_session], :per_page => 10
  end
end
