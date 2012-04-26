class AccountingController < ApplicationController
  if $g_im_online && $g_ct_online
    layout "fluid-admin-green"
  elsif $g_im_online && $g_rt_online
    layout "fluid-admin-green"
  elsif $g_im_online
    layout "fluid-admin-blue"
  elsif $g_ct_online
    layout "fluid-admin-red"
  elsif $g_rt_online
    layout "fluid-admin-gray"  
  else
    layout "fluid-admin-green"  
  end

  before_filter :login_required
  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location

  def index
    accounting_history
    render :action => 'accounting_history'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def accounting_history
		if params[:start_date].nil? && (session[:account_start_date].nil? || session[:account_start_date].blank?)
			@start_date = Order.minimum(:created_at)
			@end_date = Order.maximum(:created_at)
		elsif !params[:start_date].nil?
			@start_date = DateTime.new(y=params[:start_date][:year].to_i,m=params[:start_date][:month].to_i,d=params[:start_date][:day].to_i,h=0,min=0,s=0)
			@end_date = DateTime.new(y=params[:end_date][:year].to_i,m=params[:end_date][:month].to_i,d=params[:end_date][:day].to_i,h=23,min=59,s=59)
		else
			@start_date = session[:account_start_date]
			@end_date = session[:account_end_date]
		end
		session[:account_start_date] = @start_date
		session[:account_end_date] = @end_date
    if params[:payment_item_id].nil? || params[:payment_item_id].blank?
    	@payment_item_id = ""
    else
    	@payment_item_id = params[:payment_item_id]
    	@payment_item = PaymentItem.find(@payment_item_id)
    end
    if params[:per_page] == "100"
      @per_page = 100
    else
      @per_page = 10
    end
    if params[:participant_id].nil?  || params[:participant_id].blank?
      @participant_id = ""
    else
      @participant_id = params[:participant_id]
      @participant = Participant.find_by_id(@participant_id)
    end
    @order_pages, @orders = paginate_collection Order.sorted_order_array(@start_date, @end_date, @payment_item_id, @participant_id), :page => @params[:page], :per_page => @per_page
    @participants = Participant.find(:all, :select => "DISTINCT participants.id, participants.first_name, participants.last_name, participants.mi", :joins => " INNER JOIN orders ON orders.participant_id = participants.id", :order => "last_name, first_name")
    @payment_items = PaymentItem.find(:all)
  end
    
  def pending_items
		if params[:overdue_items].nil?			
			@overdue_items = false
			if params[:start_date].nil? && (session[:account_start_date].nil? || session[:account_start_date].blank?)
				@start_date = LineItem.minimum(:payment_due_date)
				@end_date = LineItem.maximum(:payment_due_date)
			elsif !params[:start_date].nil?
				@start_date = DateTime.new(y=params[:start_date][:year].to_i,m=params[:start_date][:month].to_i,d=params[:start_date][:day].to_i,h=0,min=0,s=0)
				@end_date = DateTime.new(y=params[:end_date][:year].to_i,m=params[:end_date][:month].to_i,d=params[:end_date][:day].to_i,h=11,min=59,s=59)
			else
				@start_date = session[:account_start_date]
				@end_date = session[:account_end_date]
			end
			session[:account_start_date] = @start_date
			session[:account_end_date] = @end_date
		else
			@overdue_items = true
			@start_date = LineItem.minimum(:payment_due_date)
			@end_date = Time.now
		end
    if params[:payment_item_id].nil? || params[:payment_item_id].blank?
    	@payment_item_id = ""
    else
    	@payment_item_id = params[:payment_item_id]
    	@payment_item = PaymentItem.find(@payment_item_id)
    end
    if params[:per_page] == "100"
      @per_page = 100
    else
      @per_page = 10
    end
    if params[:participant_id].nil?  || params[:participant_id].blank?
      @participant_id = ""
    else
      @participant_id = params[:participant_id]
      @participant = Participant.find_by_id(@participant_id)
    end
    @line_item_pages, @line_items = paginate_collection LineItem.sorted_line_item_array(@start_date, @end_date, @payment_item_id, @participant_id), :page => @params[:page], :per_page => @per_page
    @participants = Participant.find(:all, :select => "DISTINCT participants.id, participants.first_name, participants.last_name, participants.mi", :joins => " INNER JOIN line_items ON line_items.participant_id = participants.id", :order => "last_name, first_name")
    @payment_items = PaymentItem.find(:all)
  end


	def accounting_per_item
		if params[:start_date].nil?
			@start_date = LineItem.minimum(:created_at)
			@end_date = LineItem.maximum(:created_at)
		else
			@start_date = DateTime.new(y=params[:start_date][:year].to_i,m=params[:start_date][:month].to_i,d=params[:start_date][:day].to_i,h=0,min=0,s=0)
			@end_date = DateTime.new(y=params[:end_date][:year].to_i,m=params[:end_date][:month].to_i,d=params[:end_date][:day].to_i,h=23,min=59,s=59)
		end
		if !params[:ct_session_id].nil? && !params[:ct_session_id].blank?
			@ct_session = CtSession.find_by_id(params[:ct_session_id])
			@ct_rosters = @ct_session.ct_rosters.find(:all)
			@ct_session_id = params[:ct_session_id]
		else
			@ct_session_id = ""
		end	
		if !params[:im_sport_id].nil? && !params[:im_sport_id].blank?
			@im_sport = ImSport.find_by_id(params[:im_sport_id])
			@im_teams = ImTeam.teams_for_sport(@im_sport.id)
			@im_sport_id = params[:im_sport_id]
		else
			@im_sport_id = ""
		end
		@ct_sessions = CtSession.find(:all)
		@im_sports = ImSport.find(:all)
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
