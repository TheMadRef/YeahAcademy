class AccountController < ApplicationController
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
	
  verify :method => :post, :only => [ :destroy, :begin_reset_password],
         :redirect_to => { :controller => '/home', :action => 'index' }

  before_filter :login_required, :only => [ :list, :destroy, :new_admin, :my_account, :my_profile, :update_profile, :my_family, :new_family_member, :create_family_member, :edit_family_member, :update_family_member ]
	before_filter :require_id, :only => [:edit_family_member]

  def index
    if User.count == 0
      redirect_to :action => 'signup'
    else
      redirect_to :action => 'list'
    end
  end

  def list
  	if !is_admin?
  		redirect_to :controller => '/home', :action => 'index'
  	else
	    store_location
	    if params[:per_page] == "1000"
	      @per_page = 1000      
	    else
	      @per_page = 10
	    end
	    if params[:sort_by] == "name"
	      @user_pages, @users = paginate :users, :order => "participants.last_name, participants.first_name", :select => "users.id", :joins => "INNER JOIN participants ON participants.id = users.participant_id", :per_page => @per_page
	      @sort = "name"
	    else
	      @user_pages, @users = paginate :users, :per_page => @per_page, :order => 'login', :select => 'id'
	      @sort = "regular"
	    end
		end	
  end

  def login
    return unless request.post?
    @login = params[:login] # remember login name in case login fails
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      if current_user.admin?
        $g_admin = true
	      redirect_back_or_default :controller => '/admin'
	      flash[:notice] = "Logged in successfully"
      else
        $g_admin = false
    		if $g_require_membership_fee
    			if $g_application_fee > 0
    				if !current_user.participant.paid_application_fee
	    				if LineItem.find(:first, :conditions => ["participant_id = ? AND payment_item_id = ?", current_user.participant_id, 6] ).nil?
				    		line_item = LineItem.new
				    		line_item.participant_id = current_user.participant_id
				    		line_item.payment_item_id = 6
				    		line_item.price = $g_application_fee
				    		line_item.comment = "One time application fee"
				    		line_item.payment_due_date = Time.now
				    		line_item.save
	    				end
	    			end
	    		end
	    		if $g_membership_fee > 0
	    			if !current_user.participant.paid_membership_fee
	    				if LineItem.find(:first, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 7] ).nil?
				    		line_item = LineItem.new
				    		line_item.participant_id = current_user.participant_id
				    		line_item.payment_item_id = 7
				    		line_item.price = $g_membership_fee
				    		line_item.comment = "Yearly membership fee"
				    		line_item.payment_due_date = Time.now
				    		line_item.save
	    				end
    				end
    			end
    		end
  			if $g_require_membership_fee && (($g_membership_fee > 0 && !current_user.participant.paid_membership_fee) || ($g_application_fee > 0 && !current_user.participant.paid_application_fee))
		    	flash[:warning] = "You must pay your membership fees"
		    	redirect_to :controller => '/shopping_cart', :action => 'pending_items'
		    else
		      if $g_ct_online && !$g_im_online && !$g_rt_online
			      redirect_back_or_default :controller => '/ct/client/home'
			    elsif !$g_ct_online && $g_im_online && !$g_rt_online
			      redirect_back_or_default(:controller => '/im/client/home')
			    elsif !$g_ct_online && $g_im_online && !$g_rt_online
	 		      redirect_back_or_default(:controller => '/rt/client/home')
	 				else
			      redirect_back_or_default(:controller => '/home') 				
					end
		      flash[:notice] = "Logged in successfully"
		    end
    	end
    else
      flash[:error] = "Login name and/or password is invalid."
    end
  end

  def signup
  	if $g_require_category
    	@categories_array = Category.sorted_category_for_select
    end
    @participant_custom_fields = ParticipantCustomField.find(:all, :conditions => ["required = ?", true])
    @participant_fields =  ParticipantFormOrder.find(:all, :select => "participant_form_orders.*", :joins => " LEFT JOIN participant_custom_fields ON participant_custom_fields.id = participant_form_orders.participant_custom_field_id", :conditions => ["participant_form_orders.participant_column_required = ? OR participant_custom_fields.required = ?", true, true], :order => 'participant_form_orders.sort_number')		
    if !request.post?    
      @user = User.new
      @participant = Participant.new
	    @participant.custom_field_values = []
	    for custom_field in @participant_custom_fields
				@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, 0, custom_field.inheritable)
	    end
      return
    end
    @user = User.new(params[:user])
    temp = Participant.new(params[:participant])
    temp.custom_field_values = []
    for custom_field in @participant_custom_fields
			temp.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
    end
    if !$g_require_member_number
      temp.participant_number = temp.email
    end
    @participant = Participant.find_by_participant_number(temp.participant_number)
    if @participant.nil?
      @participant = temp
      if $g_verify_participants
        if $g_require_member_number
          flash[:error] = "Your member number is not in our database."
        else
          flash[:error] = "Your email address is not in our database."
        end
        return
      end
    else
      if $g_verify_participants
        if temp.first_name.length == 0
          flash[:error] = "You must enter your first name"
          @participant = temp
          return
        end
        if @participant.last_name.upcase[0, temp.last_name.length] != temp.last_name.upcase || @participant.first_name.upcase[0, temp.first_name.length] != temp.first_name.upcase
          flash[:error] = "The member information (first and/or last name) you have entered does not match the information in our database."
          @participant = temp
          return
        end
      end
      @participant.email = temp.email
      @participant.phone = temp.phone
      @participant.address_line_1 = temp.address_line_1
      @participant.address_line_2 = temp.address_line_2
      @participant.city = temp.city
      @participant.state = temp.state
      @participant.zip = temp.zip
      @participant.terms_and_conditions = temp.terms_and_conditions
      @participant.im_terms_and_conditions = temp.im_terms_and_conditions
      @participant.ct_terms_and_conditions = temp.ct_terms_and_conditions
      @participant.email_confirmation = temp.email_confirmation
      if @participant.terms_and_conditions
        @participant.terms_and_conditions_timestamp = Time.now
      end
      if @participant.im_terms_and_conditions
        @participant.im_terms_and_conditions_timestamp = Time.now
      end
      if @participant.ct_terms_and_conditions
        @participant.ct_terms_and_conditions_timestamp = Time.now
      end
      @participant.custom_field_values = temp.custom_field_values
    end
    Participant.transaction do
      @user.participant = @participant
      @participant.save!
      @user.admin = false
      @user.save!
    	# save or update custom field data
    	for custom_field in @participant_custom_fields
  			custom_field_record = ParticipantCustomFieldEntry.new
  			custom_field_record.participant_id = @participant.id
  			custom_field_record.participant_custom_field_id = custom_field.id
    		custom_field_record.field_data = @participant.custom_field_values[custom_field.id]
				custom_field_record.save!
    	end
      self.current_user = @user
      $g_admin = false
      # after sign up go to home page
      redirect_to :controller => '/home', :action => 'index'
      flash[:notice] = "Thanks for signing up!"
    end

  rescue ActiveRecord::RecordInvalid
    @user.valid?
    @participant.participant_number = temp.participant_number
    @rendering = true
  end
  
  def my_account
    if logged_in?
      @user = current_user
      if !current_user.admin?
      	@participant = current_user.participant
	    	@participant_custom_fields = ParticipantCustomField.find(:all, :conditions => ["required = ?", true])
	    	@participant.custom_field_values = []
		    @participant_fields =  ParticipantFormOrder.find(:all, :select => "participant_form_orders.*", :joins => " LEFT JOIN participant_custom_fields ON participant_custom_fields.id = participant_form_orders.participant_custom_field_id", :conditions => ["participant_form_orders.participant_column_required = ? OR participant_custom_fields.required = ?", true, true], :order => 'participant_form_orders.sort_number')		
		  	if $g_require_category
		    	@categories_array = Category.sorted_category_for_select
		    end
    	end  
      if !request.post?    
		    if !current_user.admin?
			    for custom_field in @participant_custom_fields
						@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, @participant.parent_id, custom_field.inheritable)
			    end
      	end
        return
      end
      Participant.transaction do
        if !@user.admin
			    for custom_field in @participant_custom_fields
						@participant.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
			    end
          @participant.update_attributes!(params[:participant])
          if @participant.terms_and_conditions
            @participant.terms_and_conditions_timestamp = Time.now
          end
          if @participant.im_terms_and_conditions
            @participant.im_terms_and_conditions_timestamp = Time.now
          end
          if @participant.ct_terms_and_conditions
            @participant.ct_terms_and_conditions_timestamp = Time.now
          end
          if !$g_require_member_number
            new_participant = Participant.new(params[:participant])
            if @participant.email != new_participant.email
              @participant.participant_number = new_participant.email
            end
          end          
          @participant.save!
		    	# save or update custom field data
		    	for custom_field in @participant_custom_fields
		    		custom_field_record = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", @participant.id, custom_field.id])
		    		if custom_field_record.nil?
		    			custom_field_record = ParticipantCustomFieldEntry.new
		    			custom_field_record.participant_id = @participant.id
		    			custom_field_record.participant_custom_field_id = custom_field.id
		    		end
		    		custom_field_record.field_data = @participant.custom_field_values[custom_field.id]
						custom_field_record.save!
		    	end
		    	#Check if participant has family members
		    	@family_members = @participant.participants.find(:all)
          for family_member in @family_members
            family_member.custom_field_values = []
  			    for custom_field in @participant_custom_fields
  						family_member.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, family_member.id, family_member.parent_id, custom_field.inheritable)
  			    end
            if @participant.terms_and_conditions
              family_member.terms_and_conditions = true
              family_member.terms_and_conditions_timestamp = Time.now
            end
            if @participant.im_terms_and_conditions
              family_member.im_terms_and_conditions = true
              family_member.im_terms_and_conditions_timestamp = Time.now
            end
            if @participant.ct_terms_and_conditions
              family_member.ct_terms_and_conditions = true
              family_member.ct_terms_and_conditions_timestamp = Time.now
            end
            family_member.save!          
          end
        end
        @user.update_attributes!(params[:user])
        self.current_user = @user
        # after sign up go to home page
        flash[:notice] = "Your account settings have been edited!"
        if session[:add_class_after_update]
          redirect_to :controller => '/ct/roster', :action => 'join_class' , :id => session[:add_class_after_update]
          session[:add_class_after_update] = nil
        else
          redirect_to :controller => '/home', :action => 'index'
        end
      end
    end
    
  rescue ActiveRecord::RecordInvalid
    @user.valid?
    @rendering = true
  end
  
  def my_profile
    @participant = current_user.participant
    @categories_array = Category.sorted_category_for_select
    @participant_custom_fields = ParticipantCustomField.find(:all)
    @participant.custom_field_values = []
    @participant_fields =  ParticipantFormOrder.find(:all, :conditions => ["show_field = ?", true], :order => 'sort_number')		
    for custom_field in @participant_custom_fields
			@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, @participant.parent_id, custom_field.inheritable)
    end
  end
  

  def update_profile
    @participant = current_user.participant
    @participant_custom_fields = ParticipantCustomField.find(:all)
    @participant_fields =  ParticipantFormOrder.find(:all, :conditions => ["show_field = ?", true], :order => 'sort_number')		
    @participant.custom_field_values = []
    for custom_field in @participant_custom_fields
			@participant.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
    end
    Participant.transaction do
    	@participant.update_attributes!(params[:participant])

      if !$g_require_member_number
        new_participant = Participant.new(params[:participant])
        if @participant.email != new_participant.email
          @participant.participant_number = new_participant.email
        end
        @participant.save!
			end
    	# save or update custom field data
    	for custom_field in @participant_custom_fields
    		custom_field_record = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", @participant.id, custom_field.id])
    		if custom_field_record.nil?
    			custom_field_record = ParticipantCustomFieldEntry.new
    			custom_field_record.participant_id = @participant.id
    			custom_field_record.participant_custom_field_id = custom_field.id
    		end
    		custom_field_record.field_data = @participant.custom_field_values[custom_field.id]
				custom_field_record.save!
    	end
			
      flash[:notice] = 'Your Profile was successfully updated.'
      redirect_to :controller => '/home', :action => 'index'
    end

  rescue ActiveRecord::RecordInvalid => e
    @categories_array = Category.sorted_category_for_select
    @rendering = true
    render :action => 'my_profile'
  end

  def my_family
  	@participants = Participant.find(:all, :conditions => ["parent_id = ?", current_user.participant_id])
  end

  def new_family_member
    @participant = Participant.new
    @categories_array = Category.sorted_category_for_select
    @participant.phone = current_user.participant.phone
    @participant.email = current_user.participant.email
    @participant.address_line_1 = current_user.participant.address_line_1
    @participant.address_line_2 = current_user.participant.address_line_2
    @participant.mi = current_user.participant.mi
    @participant.city = current_user.participant.city
    @participant.state = current_user.participant.state
    @participant.zip = current_user.participant.zip
    @participant.parent_id = current_user.participant_id
    @participant.yeah_code = current_user.participant.yeah_code
    @participant_custom_fields = ParticipantCustomField.find(:all)
    @participant.custom_field_values = []
    for custom_field in @participant_custom_fields
			@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, @participant.parent_id, custom_field.inheritable)
    end
    @participant_fields =  ParticipantFormOrder.find(:all, :conditions => ["show_field = ?", true], :order => 'sort_number')		
  end

	def create_family_member
    if params[:participant].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @participant = Participant.new(params[:participant])
	    @participant_custom_fields = ParticipantCustomField.find(:all)
	    @participant.custom_field_values = []
	    for custom_field in @participant_custom_fields
				@participant.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
	    end
	    @participant_fields =  ParticipantFormOrder.find(:all, :conditions => ["show_field = ?", true], :order => 'sort_number')		
      if !$g_require_member_number
        if @participant.email != current_user.participant.email
        	@participant.participant_number = @participant.email
        else
        	@participant.participant_number = @participant.email + (Participant.count("parent_id = #{current_user.participant_id}") + 1).to_s
        end
      end
      Participant.transaction do
				@participant.parent_id = current_user.participant_id
				@participant.ct_active = current_user.participant.ct_active
        @participant.save!

	    	# save or update custom field data
	    	for custom_field in @participant_custom_fields
    			custom_field_record = ParticipantCustomFieldEntry.new
    			custom_field_record.participant_id = @participant.id
    			custom_field_record.participant_custom_field_id = custom_field.id
	    		custom_field_record.field_data = @participant.custom_field_values[custom_field.id]
					custom_field_record.save!
	    	end

        flash[:notice] = 'Family member was successfully created.'
        redirect_to :action => 'my_family'
      end
		end		

  rescue ActiveRecord::RecordInvalid => e
    @categories_array = Category.sorted_category_for_select
		@rendering = true
    render :action => 'new_family_member'
	end

	def edit_family_member
		@participant = Participant.find(params[:id])
		if @participant.parent_id != current_user.participant_id
			flash[:error] = 'Unauthorized'
			redirect_to :controller => 'home', :action => 'index'
		else
			@categories_array = Category.sorted_category_for_select
	    @participant_custom_fields = ParticipantCustomField.find(:all)
	    @participant.custom_field_values = []
	    for custom_field in @participant_custom_fields
				@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, @participant.parent_id, custom_field.inheritable)
	    end
		end
    @participant_fields =  ParticipantFormOrder.find(:all, :conditions => ["show_field = ?", true], :order => 'sort_number')		
	end

	def update_family_member
		@participant = Participant.find(params[:id])
		if @participant.parent_id != current_user.participant_id
			flash[:error] = 'Unauthorized'
			redirect_to :controller => 'home', :action => 'index'
		else
	    if !$g_require_member_number
	      old_participant = Participant.find(params[:id])
	    end
	    @participant = Participant.find(params[:id])
	    @participant_custom_fields = ParticipantCustomField.find(:all)
	    @participant_fields =  ParticipantFormOrder.find(:all, :conditions => ["show_field = ?", true], :order => 'sort_number')		
	    @participant.custom_field_values = []
	    for custom_field in @participant_custom_fields
				@participant.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
	    end
	    Participant.transaction do
	      @participant.update_attributes!(params[:participant])
	      if !$g_require_member_number
	        if @participant.email != old_participant.email
		        if @participant.email != current_user.participant.email
		        	@participant.participant_number = @participant.email
		        else
		        	@participant.participant_number = @participant.email + (Participant.count("parent_id = #{current_user.participant_id}") + 1).to_s
		        end
	        end
	        @participant.save!
	      end
    		# save or update custom field data
		  	for custom_field in @participant_custom_fields
		  		custom_field_record = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", @participant.id, custom_field.id])
		  		if custom_field_record.nil?
		  			custom_field_record = ParticipantCustomFieldEntry.new
		  			custom_field_record.participant_id = @participant.id
		  			custom_field_record.participant_custom_field_id = custom_field.id
		  		end
		  		custom_field_record.field_data = @participant.custom_field_values[custom_field.id]
					custom_field_record.save!
		  	end
	      flash[:notice] = 'Family Member was successfully updated.'
	      redirect_to :action => 'my_family'
	    end
		end
  rescue ActiveRecord::RecordInvalid => e
    @categories_array = Category.sorted_category_for_select
		@rendering = true
    render :action => 'edit_family_member'
	end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    $g_admin = false
    flash[:notice] = "You have been logged out."
    # always log out to the home page unless a specified logout page was defined
    if $g_logout_link.blank? || $g_logout_link.nil?
	    redirect_to :controller => '/home', :action => 'index'
	  else
	  	redirect_to $g_logout_link
	  end 
  end
  
  def new_admin
  	if !is_admin?
  		redirect_to :controller => '/home', :action => 'index'
  	else
	    store_location
	    @user = User.new(params[:user])
	    return unless request.post?
	    if params[:user].nil?
	      redirect_to :controller => '/home', :action => 'index'
	    else
	      @user.participant = nil
	      @user.admin = true
	      @user.save!
	      flash[:notice] = "New user added as Administrator"
	      redirect_to :action => 'list'
	    end
		end
		    
  rescue ActiveRecord::RecordInvalid
    @user.valid?
    render :action => 'new_admin'
  end
  
  def destroy
    if params[:id].nil? || !is_admin?
      redirect_to :controller => '/home', :action => 'index'
    else
      User.find(params[:id]).destroy
      flash[:notice] = "User deleted."
      redirect_to :action => 'list'
    end
  end
  
  def impersonate
    if params[:id].nil? || !is_admin?
      redirect_to :controller => '/home', :action => 'index'
    else
      self.current_user.forget_me
      cookies.delete :auth_token
      reset_session
      $g_admin = false
      self.current_user = User.find(params[:id])
      flash[:notice] = "You are impersonating user #{current_user.login}."
      redirect_to :controller => '/ct/client/home'
    end
  end
  
  def forgot_password
  end
  
  def begin_reset_password
    @participant_number = params[:participant_number]
    if $g_require_member_number
      @email = params[:email]
    else
      @email = @participant_number
    end
    @participant = Participant.find_by_participant_number(@participant_number)
    if @participant.nil?
      flash[:error] = 'participant number not found in database'
      render :action => 'forgot_password'
    else
      if @participant.email.upcase != @email.upcase
        flash[:error] = 'participant number / email combination not found in database'
        render :action => 'forgot_password'
      else
        @user = User.find(:first, :conditions => ['participant_id = ?', @participant.id])
        if @user.nil?
          flash[:error] = 'no user account found for participant number'
          render :action => 'forgot_password'
        else
          @user.reset_password = ImCaptainCard.new_password(6)
          if @user.save
            email = ResetPasswordMailer.create_reset_password(@user, @participant, build_url())
            ResetPasswordMailer.deliver(email)
            # User the command below to test the email sending, 
            # render(:text => "<pre>" + email.encoded + "</pre>" )            
             redirect_to :action => 'reset_password_pending'
          else
            flash[:error] = 'could not reset password for this account'
            render :action => 'forgot_password'
          end         
        end
      end
    end
  end
  
  def reset_password_pending
  end
  
  def complete_reset_password
    if request.post?    
      temp_user = User.new(params[:user])
      @user = User.find(:first, :conditions => ['login = ?', temp_user.login])  
      if @user.nil?
        flash[:error] = 'no account found with given user name and temporary password'
        @user = User.new(params[:user])
      elsif @user.reset_password == ""
        @user = User.new(params[:user])
        flash[:error] = 'Invalid Request. Password for selected user can not be reset.'
      elsif @user.reset_password != temp_user.reset_password
        @user = User.new(params[:user])
        flash[:error] = 'No accout found with given user name and temporary password.'
      elsif temp_user.password == ""
        @user = User.new(params[:user])
        flash[:error] = 'New password may not be blank.'        
      else    
        @user.password = temp_user.password
        @user.password_confirmation = temp_user.password_confirmation
        @user.reset_password = ""
        if @user.save
          flash[:notice] = 'Account Password has been reset. Logged in successfully'
          self.current_user = @user
          redirect_to(:controller => '/home', :action => 'index')
          if current_user.admin?
            $g_admin = true
          else
            $g_admin = false
          end
        else
          @user.reset_password = temp_user.reset_password
        end
      end    
    end 
  end

  protected
end
