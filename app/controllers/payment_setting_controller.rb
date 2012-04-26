class PaymentSettingController < ApplicationController
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

  def index
    show
    render :action => 'show'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :update ],
         :redirect_to => { :action => :show }

  def show
    @payment_setting = PaymentSetting.find(1)
  end

  def edit
    @payment_setting = PaymentSetting.find(1)
    if !@payment_setting.cfm_authorization
      redirect_to :action => 'show'
      flash[:error] = 'You have not activated the online payment feature.'
    end
  end

  def update
    @payment_setting = PaymentSetting.find(1)
    if @payment_setting.update_attributes(params[:payment_setting])
      flash[:notice] = 'Payment Settings were successfully updated.'
      redirect_to :action => 'show'
    else
      render :action => 'edit'
    end
  end
end
