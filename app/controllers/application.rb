# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	
  include AuthenticatedSystem
	# set customer database
  before_filter :set_customer_database

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_facilitrax_session_id'
  # "remember me" functionality
  before_filter :login_from_cookie
  before_filter :set_session_variables_if_login
	
  
  def set_customer_database
  	if session[:customer_id].nil?
  		session[:customer_id] = params["customerid"]
  	end
  	if !session[:customer_id].nil? && !session[:customer_id].blank?
  		db_name = "facilitrax_" + session[:customer_id].to_s
			ActiveRecord::Base.establish_connection(
	      :adapter  => "mysql",
  	    :host     => "imonlinemysql.recsolutions.com",
    	  :username => "root",
      	:password => "miguel75",
      	:database => db_name
 			)
 			set_session_variables  		
		end
  end
    
  def set_session_variables_if_login
	if MasterSetting.find_by_id(1).nil?
		master_settings = MasterSetting.new
		master_settings.verify_participants = false
		master_settings.master_terms_and_conditions = false
		master_settings.master_terms_and_conditions_text = 'The master terms and conditions option makes it mandatory for all participants to accept the conditions listed on this text field before creating an account.  Thus, the administrator will not be able to add this participant to any events unless the participant creates an account.'
		master_settings.require_phone_number = false
		master_settings.require_address = false
		master_settings.save
	end
    set_session_variables
    if $g_database_version < 1
	    if EmailCustomText.find(:first, :conditions => ["id = ?", 1]).nil?
	    	email_custom_text = EmailCustomText.new
	    	email_custom_text.save
	    end
	    if PaymentItem.find(:first, :conditions => ["id = ?", 6]).nil?
	    	payment_item = PaymentItem.new
	    	payment_item.payment_item = 'Application Fee'
	    	payment_item.save
	    end
	    if PaymentItem.find(:first, :conditions => ["id = ?", 7]).nil?
	    	payment_item = PaymentItem.new
	    	payment_item.payment_item = 'Membership Fee'
	    	payment_item.save
	    end
	    master_settings = MasterSetting.find(1)
	    master_settings.database_version = 1
	    master_settings.save
	    $g_database_version = 1
	  end
	  if $g_database_version < 2
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Team Number']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Team Number"
	  		column_header_code.display_name = "Team #"
	  		column_header_code.column_name = "team_number"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	column_header_code = ImColumnHeaderCode.find(:first, :conditions => ["header_name =?", 'Team Name'])
	  	if column_header_code.nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Team Name"
	  		column_header_code.display_name = "Team Name"
	  		column_header_code.column_name = "team_name"
	  		column_header_code.alignment = "left"
	  	end
  		column_header_code.link_to_team = true
  		column_header_code.save
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Jersey Color']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Jersey Color"
	  		column_header_code.display_name = "Color"
	  		column_header_code.column_name = "im_color.color_name"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Wins']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Wins"
	  		column_header_code.display_name = "W"
	  		column_header_code.column_name = "wins"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Losses']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Losses"
	  		column_header_code.display_name = "L"
	  		column_header_code.column_name = "losses"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Ties']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Ties"
	  		column_header_code.display_name = "T"
	  		column_header_code.column_name = "ties"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Winning Percentage']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Winning Percentage"
	  		column_header_code.display_name = "%"
	  		column_header_code.column_name = "winning_percentage"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Offense:Off.']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Offense:Off."
	  		column_header_code.display_name = "Off."
	  		column_header_code.column_name = "offense"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Defense:Def.']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Defense:Def."
	  		column_header_code.display_name = "Def."
	  		column_header_code.column_name = "defense"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Sportsmanship']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Sportsmanship"
	  		column_header_code.display_name = "S.R."
	  		column_header_code.column_name = "sportsmanship"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Rating Score']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Rating Score"
	  		column_header_code.display_name = "Rating Score"
	  		column_header_code.column_name = "rating"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Ranking']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Ranking"
	  		column_header_code.display_name = "Ranking"
	  		column_header_code.column_name = "ranking"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Game:Games']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Game:Games"
	  		column_header_code.display_name = "Games"
	  		column_header_code.column_name = "games"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end	  	
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Offense:Sets Won']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Offense:Sets Won"
	  		column_header_code.display_name = "Sets Won"
	  		column_header_code.column_name = "offense"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Defense:Sets Lost']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Defense:Sets Lost"
	  		column_header_code.display_name = "Sets Lost"
	  		column_header_code.column_name = "defense"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Second Offense:Points For']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Second Offense:Points For"
	  		column_header_code.display_name = "Points For"
	  		column_header_code.column_name = "points_scored"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
	  	if ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", 'Second Defense:Points Against']).nil?
	  		column_header_code = ImColumnHeaderCode.new
	  		column_header_code.header_name = "Second Defense:Points Against"
	  		column_header_code.display_name = "Points Against"
	  		column_header_code.column_name = "points_allowed"
	  		column_header_code.alignment = "center"
	  		column_header_code.save
	  	end
		end
	  if !ImColumnHeader.find(:first, :conditions => ["im_column_header_code_id IS NULL"]).nil?
	  	column_headers = ImColumnHeader.find(:all, :conditions => ["im_column_header_code_id IS NULL"])
	  	for column_header in column_headers
	  		column_header.im_column_header_code_id = ImColumnHeaderCode.find(:first, :conditions => ["header_name = ?", column_header.header_name]).id
				column_header.save
			end
		end
		if PaymentType.find_by_id(1).nil?
		    PaymentType.create(:payment_type => 'Administrator Override', :admin_pay => true)    
    		PaymentType.create(:payment_type => 'Online Payment - Authorize.Net', :admin_pay => false)
		    PaymentType.create(:payment_type => 'Online Payment - Pay Pal', :admin_pay => false)    
	    	PaymentType.create(:payment_type => 'Cash', :admin_pay => true)    
		    PaymentType.create(:payment_type => 'Check', :admin_pay => true)    
		    PaymentType.create(:payment_type => 'Credit Card (Manual)', :admin_pay => true)    
		    PaymentType.create(:payment_type => 'Pay Pal (Manual)', :admin_pay => true)    
		    PaymentType.create(:payment_type => 'Campus ID Card (Manual)', :admin_pay => true)    
		    PaymentType.create(:payment_type => 'Online Payment - Nelix', :admin_pay => false)
		end		
  end

  def set_session_variables
    if $g_im_online
      im_settings = ImSetting.find(1)
      $g_allow_multiple_colors = im_settings.allow_multiple_colors   
      $g_captain_cards = im_settings.captain_cards
      $g_free_agents = im_settings.free_agents
      $g_captain_limit_per_division = im_settings.captain_limit_per_division
      $g_captain_limit_per_league = im_settings.captain_limit_per_league
      $g_captain_limit_per_sport = im_settings.captain_limit_per_sport
      $g_overall_captain_limit = im_settings.overall_captain_limit
      $g_verify_im_eligibility = im_settings.verify_im_eligibility
      $g_participant_roster_limit_per_sport = im_settings.participant_roster_limit_per_sport
      $g_participant_roster_limit_per_league = im_settings.participant_roster_limit_per_league
      $g_master_im_terms_and_conditions = im_settings.master_im_terms_and_conditions
      $g_team_terms_and_conditions = im_settings.team_terms_and_conditions
      $g_roster_terms_and_conditions = im_settings.roster_terms_and_conditions
      $g_payment_option = im_settings.im_payment_option_id
    end
    if $g_ct_online
      ct_settings = CtSetting.find(1)
      $g_participant_limit_per_class = ct_settings.participant_limit_per_class
      $g_participant_overall_limit = ct_settings.participant_overall_limit
      $g_verify_ct_eligibility = ct_settings.verify_ct_eligibility
      $g_master_ct_terms_and_conditions = ct_settings.master_ct_terms_and_conditions
      $g_class_terms_and_conditions = ct_settings.class_terms_and_conditions
      $g_require_approval = ct_settings.require_approval
		end
    if $g_rt_online
    	rt_settings = RtSetting.find(1)
    	$g_default_start_time = rt_settings.default_start_time
    	$g_allow_team_blocks = rt_settings.allow_team_blocks
    	$g_allow_facility_blocks = rt_settings.allow_facility_blocks
    	$g_send_game_notification_emails = rt_settings.send_game_notification_emails
    	$g_require_game_acceptance = rt_settings.require_game_acceptance
    	$g_automatically_publish_assignments = rt_settings.automatically_publish_assignments	
    end
    master_settings = MasterSetting.find(1)
    $g_verify_participants = master_settings.verify_participants
    $g_master_terms_and_conditions = master_settings.master_terms_and_conditions
    $g_require_phone_number = master_settings.require_phone_number
    $g_require_address = master_settings.require_address
    $g_require_DOB = master_settings.require_DOB
    $g_require_category = master_settings.require_category
    $g_require_member_number = master_settings.require_member_number
    $g_set_number_of_days_to_pay = master_settings.default_payment_due_setting
    $g_number_of_days_to_pay = master_settings.default_payment_due_days
    $g_require_membership_fee = master_settings.require_membership_fee
    $g_application_fee = master_settings.application_fee
    $g_membership_fee = master_settings.membership_fee
    $g_auto_delete_past_due_items = master_settings.auto_delete_past_due_items
    $g_url = build_url()
    $g_return_url = master_settings.return_url
    $g_logout_link = master_settings.logout_link
    $g_database_version = master_settings.database_version
    if $g_auto_delete_past_due_items
    	line_items = LineItem.find(:all, :conditions => ["order_id IS NULL AND (payment_item_id = ? OR payment_item_id = ? OR payment_item_id = ?) and payment_due_date < ?", 1, 2, 3, (Time.now - (24*60*60))])
    	for line_item in line_items
    		if !line_item.im_team_id.nil?
    			item = ImTeam.find_by_id(line_item.im_team_id)
				if !item.nil?
					item.destroy
				end
				line_item.destroy
    		elsif !line_item.im_roster_id.nil?
    			item = ImRoster.find_by_id(line_item.im_roster_id)
				if !item.nil?
					item.destroy
				end
				line_item.destroy
    		elsif !line_item.ct_roster_id.nil?
    			item = CtRoster.find_by_id(line_item.ct_roster_id)
				if !item.nil?
					item.destroy
				end
				line_item.destroy
			end	
    	end
    end	
  end

  def paginate_collection(collection, options = {})
    default_options = {:per_page => 10, :page => 1}
    options = default_options.merge options
    
    pages = Paginator.new self, collection.size, options[:per_page], options[:page]
    first = pages.current.offset
    last = [first + options[:per_page], collection.size].min
    slice = collection[first...last]
    return [pages, slice]
  end

  def require_id
    if params[:id].nil?
      flash[:notice] = 'Not authorized'
      redirect_to(:controller => "/home", :action => "index")
    end
  end

  def verify_admin
    if !is_admin?
      flash[:notice] = 'Not authorized'
      redirect_to(:controller => "/home", :action => "index")      
    end
  end
  def approve_order(id)
    order = Order.find_by_id(id)
    line_items = order.line_items.find(:all)
    total_paid = 0
    for line_item in line_items
      if !line_item.ct_roster_id.nil?
        @ct_roster = CtRoster.find_by_id(line_item.ct_roster_id)
        @ct_roster.paid = true
        if !CtSetting.find(1).require_approval
          if @ct_roster.ct_session.s_all_bundle
            # find all sessions for the class
            all_sessions = CtSession.find(:all, :conditions => ["ct_class_id = ?", @ct_roster.ct_session.ct_class_id])
            # start a transaction
            # loop trough the session
            for ct_session in all_sessions
              # find roster and load info then save
              roster = CtRoster.find(:first, :conditions => ['ct_session_id = ? AND participant_id = ?', ct_session.id, @ct_roster.participant.id])
              if !roster.nil? 
                if !(@ct_roster.ct_session_id == ct_session.id)
                  roster.approved = true
                  roster.save
                end
              end
            end
          end
          @ct_roster.approved = true
        end
        @ct_roster.save!
      end
      if !line_item.im_roster_id.nil?
        im_roster = ImRoster.find_by_id(line_item.im_roster_id)
        im_roster.paid = true
        im_roster.save
      end
      if !line_item.im_team_id.nil?
        im_team = ImTeam.find_by_id(line_item.im_team_id)
        im_team.paid = true
        if !ImSetting.find(1).require_approval
          im_team.approved = true
        end
        im_team.save
      end      
      total_paid += line_item.price
      line_item_ids = "id #" + line_item.id.to_s
    end
    order.completed = true
    order.save  
    participant = Participant.find_by_id(order.participant_id)
    email = PaymentReceiptMailer.create_receipt(order.id, participant, total_paid, build_url())
    begin
	    PaymentReceiptMailer.deliver(email)
	    # User the command below to test the email sending, 
	    # render(:text => "<pre>" + email.encoded + "</pre>" )            
	    if PaymentSetting.find(1).receive_payment_notifications && (order.payment_type_id == 2 || order.payment_type_id == 3 || order.payment_type_id == 9)
	      email = PaymentReceiptMailer.create_notification(order.id, participant, total_paid, build_url())
	      PaymentReceiptMailer.deliver(email)    
	    end
	    flash[:notice] = line_item_ids + "Payment for $#{sprintf("%.2f", total_paid.to_s)} has been added to this account."
    rescue Exception => e
    	flash[:error] = "A problem ocurred sending notification emails - #{e}. Payment for $#{sprintf("%.2f", total_paid.to_s)} has been added to this account."
    end
  end
  
  def cancel_order(id)
    order = Order.find_by_id(id)
    if !order.nil?
	    if !order.completed
  	    line_items = order.line_items.find(:all)
    	  for line_item in line_items
      	  line_item.order_id = nil
        	line_item.save
	      end
  	    order.destroy
    	end
		end
  end

  def build_url()
    if request.port != 80
      url =  request.host_with_port()
    else
      url = request.host()
    end
    return url
  end  
  
  def find_custom_field_value(custom_field, participant, parent_id, inheritable)
  	# See if we have data already
  	current_field = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", participant, custom_field])
  	if current_field.nil?
  		# if no data check to see if parent has data and if inheritable take that data
  		if inheritable && parent_id != 0 && !parent_id.nil?
  			current_field  = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", parent_id, custom_field])
  			if current_field.nil?
  				return ""
  			else
  				return current_field.field_data
  			end
	  	else
	  		return ""
	  	end
  	else
  		return current_field.field_data
  	end
	end  		

  def seconds_fraction_to_time(seconds)
    hours = mins = 0
    if seconds >=  60 then
     mins = (seconds / 60).to_i 
     seconds = (seconds % 60 ).to_i
 
	     if mins >= 60 then
	      hours = (mins / 60).to_i 
	      mins = (mins % 60).to_i
	    end
	  end
  	[hours,mins,seconds]
  end

	def is_participant_current
		if !is_admin? && !session[:user].nil?
			if $g_require_membership_fee
				if ($g_membership_fee > 0 && !current_user.participant.paid_membership_fee) || ($g_application_fee > 0 && !current_user.participant.paid_application_fee)
		    	flash[:warning] = "You must pay your membership fees"
	    		if $g_membership_fee > 0 && !current_user.participant.paid_membership_fee && LineItem.find(:first, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 7] ).nil?
		    		line_item = LineItem.new
		    		line_item.participant_id = current_user.participant_id
		    		line_item.payment_item_id = 7
		    		line_item.price = $g_membership_fee
		    		line_item.comment = "Yearly membership fee"
		    		line_item.payment_due_date = Time.now
		    		line_item.save
  				end
		    	redirect_to :controller => '/shopping_cart', :action => 'pending_items'
				end
			end
		end
	end 

  def build_playing_area_array
    playing_areas = PlayingArea.sorted_playing_area_array(0)
    @playing_area_options = []
    for playing_area_id in playing_areas
      playing_area = PlayingArea.find(playing_area_id)
      if playing_area.parent_id == 0
        @playing_area_options << ["#{playing_area.facility.facility_name}:#{playing_area.playing_area_name}", playing_area_id]
      else
        @playing_area_options << ["#{playing_area.facility.facility_name}:#{playing_area.playing_area.playing_area_name}:#{playing_area.playing_area_name}", playing_area_id]
      end
    end
  end  
end
