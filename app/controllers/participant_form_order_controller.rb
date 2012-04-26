class ParticipantFormOrderController < ApplicationController
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
    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')
  end

  def edit
    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')
		@sort_values = []
		@field_names = []
		@show_values = []
		@report_values = []
		for field in @participant_fields
			@sort_values[field.id] = field.sort_number
			if field.participant_custom_field_id.nil?
				@field_names[field.id] = field.participant_column_human_name
				@show_values[field.id] = field.show_field
				@report_values[field.id] = field.show_on_reports
			end
		end
  end

  def update
    @participant_fields =  ParticipantFormOrder.find(:all, :order => 'sort_number')
		@sort_values = []
		@field_names = []
		@show_values = []
		@report_values = []
		for field in @participant_fields
			@sort_values[field.id] = params["sort_#{field.id}"]
			if field.participant_custom_field_id.nil?
				@field_names[field.id] = params["name_#{field.id}"]
				@show_values[field.id] = params["show_field_#{field.id}"]
				@report_values[field.id] = params["show_on_reports_#{field.id}"]
			end
		end
		ParticipantFormOrder.transaction do
			for field in @participant_fields
				@current_record = ParticipantFormOrder.find_by_id(field.id)
				@current_record.sort_number = 0
				@current_record.save!
			end
			for field in @participant_fields
				@current_record = ParticipantFormOrder.find_by_id(field.id)
				@current_record.sort_number = params["sort_#{field.id}"]
				if field.participant_custom_field_id.nil?
					@current_record.participant_column_human_name = params["name_#{field.id}"]
					@current_record.show_field = params["show_field_#{field.id}"]
					@current_record.show_on_reports = params["show_on_reports_#{field.id}"]		
				end
				@current_record.save!								
			end
      flash[:notice] = 'Participant Form Order was successfully updated.'
      redirect_to :action => 'list'			
		end

  rescue ActiveRecord::RecordInvalid => e
		render :action => 'edit'		
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
