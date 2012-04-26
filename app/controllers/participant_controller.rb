class ParticipantController < ApplicationController
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
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def search_list
    if request.post? && params[:search_type] == "id"
      @participant_number = params[:participant_number]
      @first_name = ""
      @last_name = ""
      if @participant_number == ""
        flash[:error] = 'You must enter an id number for your search.'
        @participants = nil
      else
        participant = Participant.find_by_participant_number(@participant_number)
        if participant.nil?
          flash[:error] = 'Participant not found in database.'
          @participants = nil
        else
          @participant_pages, @participants = paginate :participants, :conditions => ["member_id = ?", participant.member_id], :order => "last_name, first_name", :per_page => 15
        end
      end
    else
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      if @last_name.nil?
        @last_name = ""
      end
      if @first_name.nil?
        @first_name = ""
      end
      last_name = "%" + @last_name + "%"
      first_name = "%" + @first_name + "%"
      if @first_name == "" && @last_name == ""
        flash[:error] = 'You must enter either a first name or last name for your search.'
        @participants = nil
      elsif @first_name == ""
        @participant_pages, @participants = paginate :participants, :conditions => ["last_name LIKE ?", last_name],:order => "last_name, first_name", :per_page => 15
      elsif @last_name == ""
        @participant_pages, @participants = paginate :participants, :conditions => ["first_name LIKE ?", first_name],:order => "last_name, first_name", :per_page => 15
      else    
        @participant_pages, @participants = paginate :participants, :conditions => ["first_name LIKE ? AND last_name LIKE ?", first_name, last_name],:order => "last_name, first_name", :per_page => 15
      end        
    end
  end

  def list
    @participant_pages, @participants = paginate :participants, :order => "last_name, first_name", :per_page => 15
  end

  def show
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @participant = Participant.find(params[:id])
      @rt_user_groups = RtParticipantUserGroupRelationship.find(:all, :conditions => ["participant_id = ?", params[:id]])
      @participant_custom_fields = ParticipantCustomField.find(:all)
      @participant.custom_field_values = []
      @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')		
      for custom_field in @participant_custom_fields
  			@participant.custom_field_values[custom_field.id] = ParticipantCustomFieldEntry.find_custom_field_value(custom_field.id, @participant.id, @participant.parent_id, custom_field.inheritable)
      end
      @ct_rosters = @participant.ct_rosters.find(:all)
    end
  end
  
  def new
    @participant = Participant.new
    if $g_rt_online
      @rt_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 1], :order => 'user_group_name')
      @rt_non_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 2], :order => 'user_group_name')
      @rt_evaluator_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 3], :order => 'user_group_name')
    end
    @categories_array = Category.sorted_category_for_select
    @participant_custom_fields = ParticipantCustomField.find(:all)
    @participant.custom_field_values = []
    for custom_field in @participant_custom_fields
			@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, 0, custom_field.inheritable)
    end
    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')		
  end

  def create
    if params[:participant].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @participant = Participant.new(params[:participant])
	    @participant_custom_fields = ParticipantCustomField.find(:all)
	    @participant.custom_field_values = []
	    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')		
	    for custom_field in @participant_custom_fields
				@participant.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
	    end
      if !$g_require_member_number
        @participant.participant_number = @participant.email
      end
      Participant.transaction do
        @participant.save!

	    	# save or update custom field data
	    	for custom_field in @participant_custom_fields
    			custom_field_record = ParticipantCustomFieldEntry.new
    			custom_field_record.participant_id = @participant.id
    			custom_field_record.participant_custom_field_id = custom_field.id
	    		custom_field_record.field_data = @participant.custom_field_values[custom_field.id]
					custom_field_record.save!
	    	end

        #For rt users, process any user group selections
        rt_user_groups = RtUserGroup.find(:all)
        if !rt_user_groups[0].nil?        
          for user_group in rt_user_groups
            if params["user_group_#{user_group.id}"] != nil
              rt_participant_user_group_relationship = RtParticipantUserGroupRelationship.new
              rt_participant_user_group_relationship.participant_id = @participant.id
              rt_participant_user_group_relationship.rt_user_group_id = user_group.id
              rt_participant_user_group_relationship.save!
            end
          end
        end          

        if @participant.rt_active && !@participant.email.nil?
          email = RtJoinRequestMailer.create_admin_invite(@participant, build_url())
          RtJoinRequestMailer.deliver(email)
          # User the command below to test the email sending, 
          # render(:text => "<pre>" + email.encoded + "</pre>" )  
        end
        flash[:notice] = 'Participant was successfully created.'
        redirect_to :action => 'list'
      end
    end
        
  rescue ActiveRecord::RecordInvalid => e
    if $g_rt_online
      @rt_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 1], :order => 'user_group_name')
      @rt_non_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 2], :order => 'user_group_name')
      @rt_evaluator_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 3], :order => 'user_group_name')
    end
    @categories_array = Category.sorted_category_for_select
    @rendering = true
    render :action => 'new'
  end

  def edit
      if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      @participant = Participant.find(params[:id])
      if $g_rt_online
        @rt_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 1], :order => 'user_group_name')
        @rt_non_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 2], :order => 'user_group_name')
        @rt_evaluator_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 3], :order => 'user_group_name')
      end
	    @categories_array = Category.sorted_category_for_select
	    @participant_custom_fields = ParticipantCustomField.find(:all)
	    @participant.custom_field_values = []
	    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')		
	    for custom_field in @participant_custom_fields
				@participant.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, @participant.id, @participant.parent_id, custom_field.inheritable)
	    end
    end
  end

  def update
    if !$g_require_member_number
      old_participant = Participant.find(params[:id])
    end
    @participant = Participant.find(params[:id])
    @participant_custom_fields = ParticipantCustomField.find(:all)
    @participant.custom_field_values = []
    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')		
    for custom_field in @participant_custom_fields
			@participant.custom_field_values[custom_field.id] = params["custom_field_#{custom_field.id}"]
    end
    Participant.transaction do
      @participant.update_attributes!(params[:participant])

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
      if !$g_require_member_number
        if @participant.email != old_participant.email
          @participant.participant_number = @participant.email
        end
        @participant.save!
      end
      # Update family members for yeah code and ct_active status
    	@family_members = @participant.participants.find(:all)
      for family_member in @family_members
        family_member.custom_field_values = []
  	    for custom_field in @participant_custom_fields
  				family_member.custom_field_values[custom_field.id] = find_custom_field_value(custom_field.id, family_member.id, family_member.parent_id, custom_field.inheritable)
  	    end
        family_member.ct_active = @participant.ct_active
        family_member.yeah_code = @participant.yeah_code
        family_member.save!          
      end      
      flash[:notice] = 'Participant was successfully updated.'
      redirect_to :action => 'show', :id => @participant
    end

  rescue ActiveRecord::RecordInvalid => e
    if $g_rt_online
      @rt_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 1], :order => 'user_group_name')
      @rt_non_employee_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 2], :order => 'user_group_name')
      @rt_evaluator_groups = RtUserGroup.find(:all, :conditions => ["rt_user_group_type_id = ?", 3], :order => 'user_group_name')
    end
    @categories_array = Category.sorted_category_for_select
    @rendering = true
    render :action => 'edit'
  end
  
  def destroy
    if params[:id].nil?
      redirect_to :controller => '/home', :action => 'index'
    else
      Participant.find(params[:id]).destroy
      flash[:notice] = 'Participant was successfully deleted.'
      redirect_to :action => 'list'
    end
  end
    

  def reset_ct_master_terms_and_conditions
    Participant.update_all("ct_terms_and_conditions = false")
    Participant.update_all(["ct_terms_and_conditions_timestamp = ?", nil])
    flash[:notice] = "CT Master Terms and Conditions have been reset"
    redirect_to :action => 'global_functions'
  end    

  def reset_im_master_terms_and_conditions
    Participant.update_all("im_terms_and_conditions = false")
    Participant.update_all(["im_terms_and_conditions_timestamp = ?", nil])
    flash[:notice] = "IM Master Terms and Conditions have been reset"
    redirect_to :action => 'global_functions'
  end    

  def reset_master_terms_and_conditions
    Participant.update_all("terms_and_conditions = false")
    Participant.update_all(["terms_and_conditions_timestamp = ?", nil])
    flash[:notice] = "Master Terms and Conditions have been reset"
    redirect_to :action => 'global_functions'
  end    

  def reset_ct_eligibility
    Participant.update_all("ct_active = false")
    flash[:notice] = "CT Eligibility has been reset"
    redirect_to :action => 'global_functions'
  end    

  def reset_im_eligibility
    Participant.update_all("im_active = false")
    flash[:notice] = "IM Eligibility has been reset"
    redirect_to :action => 'global_functions'
  end    

  def reset_membership_fee_status
    Participant.update_all("paid_membership_fee = false")
    flash[:notice] = "Membership Fee status has been reset"
    redirect_to :action => 'global_functions'
  end    
  
  def reset_membership_status
    @participant = Participant.find(params[:id])
    @participant.paid_membership_fee = false
    if @participant.save
      flash[:notice] = "Participant's Membership Status set to Not Paid"
      redirect_to :action => 'show', :id => params[:id]
    else
      flash[:error] = "Could not set Membership Status.  Please edit participant"
      render :action => 'edit'
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
