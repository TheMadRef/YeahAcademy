class HomeController < ApplicationController
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
  
  before_filter :is_participant_current

  def index
    @master_setting = MasterSetting.find(1)
    if $g_ct_online
      @ct_setting = CtSetting.find(1)
    end
    if !session[:user].nil?
	    if !current_user.participant_id.nil?
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
	  	end
		end
	end
end
