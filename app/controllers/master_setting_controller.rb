class MasterSettingController < ApplicationController
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
    show
    render :action => 'show'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def show
    @master_setting = MasterSetting.find(1)
  end

  def edit
    @master_setting = MasterSetting.find(1)
  end

  def update
    @master_setting = MasterSetting.find(1)
    if @master_setting.update_attributes(params[:master_setting])
      flash[:notice] = 'Master Settings were successfully updated.'
      redirect_to :action => 'show'
      set_session_variables
      update_participant_form_order
    else
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

	def update_participant_form_order
		update_form_field("address_line_1", "address")
		update_form_field("city", "address")
		update_form_field("state", "address")
		update_form_field("zip", "address")
		update_form_field("phone", "phone")
		update_form_field("category_id", "category")
		update_form_field("date_of_birth", "DOB")
	end

	def update_form_field(column, type)
		field = ParticipantFormOrder.find(:first, :conditions => ["participant_column_name = ?", column])
		if type == "address"
			field.participant_column_required = $g_require_address
			if $g_require_address
				field.show_field = true
			end
		elsif type == "phone"
			field.participant_column_required = $g_require_phone_number
			if $g_require_phone_number
				field.show_field = true
			end
		elsif type == "category"
			field.participant_column_required = $g_require_category
			if $g_require_category
				field.show_field = true
			end
		elsif type == "DOB"
			field.participant_column_required = $g_require_DOB
			if $g_require_DOB
				field.show_field = true
			end
		end
		field.save
	end
end
