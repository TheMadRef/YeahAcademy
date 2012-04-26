class Ct::Client::HomeController < ApplicationController
  layout "fluid-client-red"

  before_filter :login_required
  before_filter :require_id, :only => [:class_information]
  
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location
  before_filter :is_participant_current
  
  def index
    @ct_setting = CtSetting.find(1)
    @ct_active_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_early_bird_date < ? AND s_late_date > ? AND s_registration_end > ? AND class_name NOT LIKE '%PSEO%'", Time.now, Time.now, Time.now, Time.now])
    @ct_early_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_early_bird_date > ? AND s_registration_end > ? AND class_name NOT LIKE '%PSEO%'", Time.now, Time.now, Time.now])
    @ct_late_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_late_date < ? AND s_registration_end > ? AND class_name NOT LIKE '%PSEO%'", Time.now, Time.now, Time.now])
    @pseo_active_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_early_bird_date < ? AND s_late_date > ? AND s_registration_end > ? AND class_name LIKE '%PSEO%'", Time.now, Time.now, Time.now, Time.now])
    @pseo_early_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_early_bird_date > ? AND s_registration_end > ? AND class_name LIKE '%PSEO%'", Time.now, Time.now, Time.now])
    @pseo_late_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_end ASC, class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_late_date < ? AND s_registration_end > ? AND class_name LIKE '%PSEO%'", Time.now, Time.now, Time.now])
    @ct_upcoming_sessions = CtSession.find(:all, :include => :ct_class, :order => "s_registration_start ASC, class_name, s_class_name", :conditions => ["s_registration_start > ? ", Time.now], :limit => 5)  
		pending_payment = Order.find(:first, :conditions => ["participant_id = ? AND completed = ?", current_user.participant_id, 0])
		if pending_payment.nil?
			pending_item = LineItem.find(:first, :conditions => ["participant_id = ? AND order_id IS NULL", current_user.participant_id], :order => "payment_due_date")    
	  	if !pending_item.nil?  && !pending_item.payment_due_date.nil? 
	  		if pending_item.payment_due_date > Time.now
	  			@warning_message = "You have pending items in your shopping cart.  Please be sure to submit payment by #{pending_item.payment_due_date}."
	  		else
	  			@warning_message = "<b>You have an over due payment on your account.  Please remit payment immediately.</b>"
				end
			end
		else
			@warning_message = "<b>Your last payment attempt was not concluded.  Please go to My Account and click on Pending Payments to complete your payment.  If you feel this is a mistake, please contact the administrator immediately.</b>"
		end
		@family_members = Participant.find(:all, :conditions => ["parent_id = ?", current_user.participant_id])
	end

  def class_list
		if is_admin?
			redirect_to :controller => '/ct/admin/class'
		else
	    @ct_session_pages, @ct_sessions = paginate :ct_sessions, :order => "ct_class_id ASC, s_registration_end ASC", :conditions => ["s_registration_start < ? AND s_registration_end > ?", Time.now, Time.now], :per_page => 10
	    @family_members = Participant.find(:all, :conditions => ["parent_id = ?", current_user.participant_id])
			@found_session = false
  	end
  end
    
  def upcoming_list
	    @ct_session_pages, @ct_sessions = paginate :ct_sessions, :include => :ct_class, :order => "class_name, s_class_name", :conditions => ["s_registration_start < ? AND s_registration_end > ?", Time.now, Time.now], :per_page => 10
  end
  
	def class_information
		@ct_class = CtClass.find(params[:id])
		@ct_sessions = @ct_class.ct_sessions.find(:all)
		@family_members = Participant.find(:all, :conditions => ["parent_id = ?", current_user.participant_id])
	end
end
