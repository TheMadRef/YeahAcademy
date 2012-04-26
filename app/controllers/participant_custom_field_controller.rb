class ParticipantCustomFieldController < ApplicationController
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
  before_filter :require_id, :only => [ :edit, :show]

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @participant_custom_field_pages, @participant_custom_fields = paginate :participant_custom_fields, :per_page => 10
  end

  def show
    @participant_custom_field = ParticipantCustomField.find(params[:id])
  end

  def new
    @participant_custom_field = ParticipantCustomField.new
  end

  def create
    @participant_custom_field = ParticipantCustomField.new(params[:participant_custom_field])
		ParticipantCustomField.transaction do
	    @participant_custom_field.save
			participant_form_order = ParticipantFormOrder.new
			participant_form_order.participant_custom_field_id = @participant_custom_field.id
			participant_form_order.sort_number = ParticipantFormOrder.maximum(:sort_number) + 1
			participant_form_order.save!
      flash[:notice] = 'Custom Field was successfully created.'
      redirect_to :action => 'list'
	  end
	
  rescue ActiveRecord::RecordInvalid => e
    render :action => 'new'
  end

  def edit
    @participant_custom_field = ParticipantCustomField.find(params[:id])
  end

  def update
    @participant_custom_field = ParticipantCustomField.find(params[:id])
    if @participant_custom_field.update_attributes(params[:participant_custom_field])
      flash[:notice] = 'Custom Field was successfully updated.'
      redirect_to :action => 'show', :id => @participant_custom_field
    else
      render :action => 'edit'
    end
  end

  def destroy
    ParticipantCustomField.find(params[:id]).destroy
    redirect_to :action => 'list'
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
