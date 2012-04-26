class ShoppingCartController < ApplicationController
  require 'paypal_caller'
  require 'cgi'
  require 'net/http'
   
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

  verify :method => :post, :only => [ :apply_credit, :destroy_credit, :process_admin_payment, :process_payment, :apply_charge, :destroy_charge ],
         :redirect_to => { :controller => '/home', :action => 'index' }


  before_filter :login_required
  before_filter :require_id, :only => [ :participant_history, :admin_pending_items, :admin_history, :admin_pending_payments, :restart_payment, :record_receipt ]

  # store loaction to user that the login screen redirects back here
  # this is becuase we are adding the Log In link atthe top of every page
  before_filter :store_location

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :update_free_agent_status, :destroy_invitation, :decline_invitation ],
         :redirect_to => { :action => :index }

  def pending_items
    @admin = false
    @team_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 2])
    @roster_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 1])      
    @class_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 3])    
    @credits = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 4])
    @charges = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 5])
    @membership_fees = LineItem.find(:all, :conditions => ["participant_id = ? AND (payment_item_id = ? OR payment_item_id = ?) AND order_id IS NULL", current_user.participant_id, 6, 7])
    @paypal = PaymentSetting.find(1).paypal
    @authorize_net = PaymentSetting.find(1).authorize_net
    @nelix = PaymentSetting.find(1).nelix
  end

  def admin_pending_items  
    store_location
    @admin = true
    @user = User.find(:first, :conditions => ["id = ?", params[:id]])
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to :controller => '/account', :action => 'list'
    else
      @team_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 2])
      @roster_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 1])      
      @class_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 3])    
      @credits = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 4]) 
      @charges = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 5]) 
      @membership_fees = LineItem.find(:all, :conditions => ["participant_id = ? AND (payment_item_id = ? OR payment_item_id = ?) AND order_id IS NULL", @user.participant_id, 6, 7]) 
      @payment_types = PaymentType.find(:all, :conditions => ["admin_pay = ?", true])
    end
  end

  def account_history
    @orders = Order.find(:all, :conditions => ["participant_id = ? AND completed = ?", current_user.participant_id, true], :order => 'created_at')
  end

  def pending_payments
    @orders = Order.find(:all, :conditions => ["participant_id = ? AND completed = ?", current_user.participant_id, false], :order => 'created_at')
    @admin = false
  end

  def admin_pending_payments
    store_location
    @user = User.find(:first, :conditions => ["id = ?", params[:id]])
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to :controller => '/account', :action => 'list'
    else
      @admin = true
      @orders = Order.find(:all, :conditions => ["participant_id = ? AND completed = ?", @user.participant_id, false], :order => 'created_at')
    end  
  end

  def participant_history
    user = User.find(:first, :conditions => ["participant_id = ?", params[:id]])
    if user.nil?
      flash[:error] = "Participant does not have an account"
      redirect_to :controller => '/participant', :action => 'list'
    else
      redirect_to :action => 'admin_history', :id => user.id
    end
  end

  def participant_pending_items
    user = User.find(:first, :conditions => ["participant_id = ?", params[:id]])
    if user.nil?
      flash[:error] = "Participant does not have an account"
      redirect_to :controller => '/participant', :action => 'list'
    else
      redirect_to :action => 'admin_pending_items', :id => user.id
    end
  end

  def admin_history
    store_location
    @user = User.find(:first, :conditions => ["id = ?", params[:id]])
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to :controller => '/account', :action => 'list'
    else
      @discount_log = DiscountLog.new
      @discount_log.participant = @user.participant
      @fee_log = FeeLog.new
      @fee_log.participant = @user.participant
      @line_item = LineItem.new
			@line_item.payment_due_date = Time.now + ($g_number_of_days_to_pay * 60 * 60 * 24)
      @orders = Order.find(:all, :conditions => ["participant_id = ? AND completed = ?", @user.participant_id, true], :order => 'created_at')
    end
  end
  
  def apply_credit
    store_location
    @discount_log = DiscountLog.new(params[:discount_log])
    @user = User.find(:first, :conditions => ["participant_id = ?", @discount_log.participant_id])
    DiscountLog.transaction do
      @discount_log.save!
      @line_item = LineItem.new
      @line_item.payment_item_id = 4
      @line_item.price = -1 * @discount_log.amount
      @line_item.participant = @discount_log.participant
      @line_item.discount_log = @discount_log
      @line_item.save!
      flash[:notice] = 'Discount/Credit applied succesfuly'
      redirect_to :action => 'admin_history', :id => @user.id
    end

  rescue ActiveRecord::RecordInvalid => e
    @orders = Order.find(:all, :conditions => ["participant_id = ?", @discount_log.participant_id], :order => 'created_at')
    render :action => 'admin_history'
  end

  def destroy_credit
    line_item = LineItem.find(params[:id])
    if line_item.order_id.nil?
      line_item.destroy
      flash[:notice] = 'Credit deleted.'
    else
      flash[:error] = 'Can not delete credit, already used for payment'
    end
    redirect_to :action => 'admin_pending_items', :id => params[:user]
  end

  def apply_charge
    store_location
    @fee_log = FeeLog.new(params[:fee_log])
    @user = User.find(:first, :conditions => ["participant_id = ?", @fee_log.participant_id])
    FeeLog.transaction do
      @fee_log.save!
      @line_item = LineItem.new(params[:line_item])
      @line_item.payment_item_id = 5
      @line_item.price = @fee_log.amount
      @line_item.participant = @fee_log.participant
      @line_item.fee_log = @fee_log
      @line_item.save!
      flash[:notice] = 'Fee/Charge applied succesfuly'
      redirect_to :action => 'admin_history', :id => @user.id
    end

  rescue ActiveRecord::RecordInvalid => e
    @orders = Order.find(:all, :conditions => ["participant_id = ?", @fee_log.participant_id], :order => 'created_at')
    render :action => 'admin_history'
  end

  def destroy_charge
    line_item = LineItem.find(params[:id])
    if line_item.order_id.nil?
      line_item.destroy
      flash[:notice] = 'Charge deleted.'
    else
      flash[:error] = 'Can not delete charge, already used for payment'
    end
    redirect_to :action => 'admin_pending_items', :id => params[:user]
  end

  def process_admin_payment
    store_location
    @admin = true
    @user = User.find(:first, :conditions => ["id = ?", params[:id]])
    if @user.nil?
      flash[:error] = "User does not exist"
      redirect_to :controller => '/account', :action => 'list'
    else
      @team_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 2])
      @roster_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 1])      
      @class_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 3])    
      @credits = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 4]) 
      @charges = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", @user.participant_id, 5])
      @membership_fees = LineItem.find(:all, :conditions => ["participant_id = ? AND (payment_item_id = ? OR payment_item_id = ?) AND order_id IS NULL", @user.participant_id, 6, 7])  
      paid_item = false
      total_paid = 0
      for line_item in @team_entries
        param_name = "line_item_" + line_item.id.to_s
        if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
          paid_item = true
          total_paid += line_item.price
        end
      end
      for line_item in @roster_entries
        param_name = "line_item_" + line_item.id.to_s
        if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
          paid_item = true
          total_paid += line_item.price
        end
      end
      for line_item in @class_entries
        param_name = "line_item_" + line_item.id.to_s
        if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
          paid_item = true
          total_paid += line_item.price
        end
      end
      for line_item in @charges
        param_name = "line_item_" + line_item.id.to_s
        if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
          paid_item = true
          total_paid += line_item.price
        end
      end
      for line_item in @membership_fees
        param_name = "line_item_" + line_item.id.to_s
        if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
          paid_item = true
          total_paid += line_item.price
        end
			end
      if !paid_item
        @payment_types = PaymentType.find(:all, :conditions => ["admin_pay = ?", true])
        flash[:error] = 'must pay at least one item'
        render :action => 'admin_pending_items', :id => @user.id
      else
        for line_item in @credits
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            paid_item = true
            total_paid += line_item.price
          end
        end
        Order.transaction do
          order = Order.new(params[:order])
          order.participant_id = @user.participant_id
          order.completed = true
          order.save!
          for line_item in @team_entries
            param_name = "line_item_" + line_item.id.to_s
            if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
              payment_item = LineItem.find(line_item.id)
              payment_item.order_id = order.id
              payment_item.save!
            end
          end
          for line_item in @roster_entries
            param_name = "line_item_" + line_item.id.to_s
            if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
              payment_item = LineItem.find(line_item.id)
              payment_item.order_id = order.id
              payment_item.save!
            end
          end
          for line_item in @class_entries
            param_name = "line_item_" + line_item.id.to_s
            if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
              payment_item = LineItem.find(line_item.id)
              payment_item.order_id = order.id
              payment_item.save!
            end
          end
          for line_item in @credits
            param_name = "line_item_" + line_item.id.to_s
            if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
              payment_item = LineItem.find(line_item.id)
              payment_item.order_id = order.id
              payment_item.save!
            end
          end
          for line_item in @charges
            param_name = "line_item_" + line_item.id.to_s
            if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
              payment_item = LineItem.find(line_item.id)
              payment_item.order_id = order.id
              payment_item.save!
            end
          end
          for line_item in @membership_fees
            param_name = "line_item_" + line_item.id.to_s
            if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
              payment_item = LineItem.find(line_item.id)
              payment_item.order_id = order.id
              payment_item.save!
            end
					end
          if total_paid < 0
            new_credit = DiscountLog.new
            new_credit.participant_id = @user.participant_id
            new_credit.comment = "Credit remaining from order number " + order.id.to_s
            new_credit.amount = total_paid * -1
            new_credit.save!
            new_line_item = LineItem.new
	        new_line_item.price = total_paid
            new_line_item.participant_id = @user.participant_id
            new_line_item.payment_item_id = 4
            new_line_item.discount_log_id = new_credit.id
            new_line_item.save!
            old_credit = DiscountLog.find(@credits[0].discount_log_id)
            old_credit.amount = old_credit.amount + total_paid
            old_credit.comment = old_credit.comment + " - Amount adjusted to reflect new credit issued as part of order " + order.id.to_s
            old_credit.save!
            old_line_item = LineItem.find(@credits[0].id)
            old_line_item.price = old_line_item.price - total_paid
            old_line_item.save!
            total_paid = 0
          end        
          approve_order(order.id)
          redirect_to :action => 'admin_history', :id => @user.id
        end 
      end
    end

  rescue ActiveRecord::RecordInvalid => e
    @payment_types = PaymentType.find(:all, :conditions => ["admin_pay = ?", true])
    flash[:error] = "There was an error in your payment"
    render :action => 'admin_pending_items'
  end
  
  def process_payment
    store_location
    @admin = false
    @team_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 2])
    @roster_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 1])      
    @class_entries = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 3])    
    @credits = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 4])
    @charges = LineItem.find(:all, :conditions => ["participant_id = ? AND payment_item_id = ? AND order_id IS NULL", current_user.participant_id, 5])
    @membership_fees = LineItem.find(:all, :conditions => ["participant_id = ? AND (payment_item_id = ? OR payment_item_id = ?) AND order_id IS NULL", current_user.participant_id, 6, 7])
    paid_item = false
    total_paid = 0
    for line_item in @team_entries
      param_name = "line_item_" + line_item.id.to_s
      if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
        paid_item = true
        total_paid += line_item.price
      end
    end
    for line_item in @roster_entries
      param_name = "line_item_" + line_item.id.to_s
      if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
        paid_item = true
        total_paid += line_item.price
      end
    end
    for line_item in @class_entries
      param_name = "line_item_" + line_item.id.to_s
      if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
        paid_item = true
        total_paid += line_item.price
      end
    end
    for line_item in @charges
      param_name = "line_item_" + line_item.id.to_s
      if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
        paid_item = true
        total_paid += line_item.price
      end
    end
    for line_item in @membership_fees
      param_name = "line_item_" + line_item.id.to_s
      if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
        paid_item = true
        total_paid += line_item.price
      end
    end
    if !paid_item
      @paypal = PaymentSetting.find(1).paypal
      @authorize_net = PaymentSetting.find(1).authorize_net
	    @nelix = PaymentSetting.find(1).nelix
      flash[:error] = 'must pay at least one item'
      render :action => 'pending_items'
    else
      for line_item in @credits
        param_name = "line_item_" + line_item.id.to_s
        if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
          paid_item = true
          total_paid += line_item.price
        end
      end
      Order.transaction do
        order = Order.new(params[:order])
        order.participant_id = current_user.participant_id
        if params[:commit] == "Express checkout using a PayPal Account"
          order.payment_type_id = 3
        elsif params[:commit] == "Pay with a major credit card through the NeLiX Gateway"
          order.payment_type_id = 9
        else
        	order.payment_type_id = 2        
        end
        order.completed = false
        order.save!
        for line_item in @team_entries
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            payment_item = LineItem.find(line_item.id)
            payment_item.order_id = order.id
            payment_item.save!
          end
        end
        for line_item in @roster_entries
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            payment_item = LineItem.find(line_item.id)
            payment_item.order_id = order.id
            payment_item.save!
          end
        end
        for line_item in @class_entries
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            payment_item = LineItem.find(line_item.id)
            payment_item.order_id = order.id
            payment_item.save!
          end
        end
        for line_item in @credits
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            payment_item = LineItem.find(line_item.id)
            payment_item.order_id = order.id
            payment_item.save!
          end
        end
        for line_item in @charges
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            payment_item = LineItem.find(line_item.id)
            payment_item.order_id = order.id
            payment_item.save!
          end
        end
        for line_item in @membership_fees
          param_name = "line_item_" + line_item.id.to_s
          if params[:pay_all] == "1" || params[param_name.to_sym] == "1"
            payment_item = LineItem.find(line_item.id)
            payment_item.order_id = order.id
            payment_item.save!
          end
        end
        if total_paid < 0
          new_credit = DiscountLog.new
          new_credit.participant_id = @user.participant_id
          new_credit.comment = "Credit remaining from order number " + order.id.to_s
          new_credit.amount = total_paid * -1
          new_credit.save!
          new_line_item = LineItem.new
		  new_line_item.price = total_paid
          new_line_item.participant_id = @user.participant_id
          new_line_item.payment_item_id = 4
          new_line_item.discount_log_id = new_credit.id
          new_line_item.save!
          old_credit = DiscountLog.find(@credits[0].discount_log_id)
          old_credit.amount = old_credit.amount + total_paid
          old_credit.comment = old_credit.comment + " - Amount adjusted to reflect new credit issued as part of order " + order.id.to_s
          old_credit.save!
          old_line_item = LineItem.find(@credits[0].id)
          old_line_item.price = old_line_item.price - total_paid
          old_line_item.save!
          total_paid = 0
        end        
        session[:AMT] = total_paid
        if total_paid == 0
          approve_order(order.id)
        elsif params[:commit] == "Express checkout using a PayPal Account"
          do_paypal_payment(order.id)
        elsif params[:commit] == "Pay with a major credit card through Authorize.Net"
          do_authorize_net_payment(order.id)
        elsif params[:commit] == "Pay with a major credit card through the NeLiX Gateway"
        	do_nelix_payment(order.id) 
        else
          flash[:error] = "Payment was not applied commit failed."
          cancel_order(order.id)
          redirect_to :action => 'pending_items'        
        end 
      end 
    end

  rescue ActiveRecord::RecordInvalid => e
    @paypal = PaymentSetting.find(1).paypal
    @authorize_net = PaymentSetting.find(1).authorize_net
    @nelix = PaymentSetting.find(1).nelix
    flash[:error] = "There was an error in your payment"
    render :action => 'pending_items'

  rescue Errno::ENOENT => exception
    @paypal = PaymentSetting.find(1).paypal
    @authorize_net = PaymentSetting.find(1).authorize_net
    @nelix = PaymentSetting.find(1).nelix
    flash[:error] = exception
    render :action => 'pending_items'
  end

  def complete_paypal_payment
    @caller =  PayPalSDKCallers::Caller.new(false)
    @token=params[:token].to_s      
    @contents, @data = @caller.call(
      {
        :method => 'GetExpressCheckoutDetails',
        :token  => @token
               
      }
    )    
    @response = CGI::parse(@data)     
    @payerid= @response["PAYERID"].to_s    
    session[:payerid] = @payerid
    if (@response["ACK"].to_s != "Failure") 
      @caller =  PayPalSDKCallers::Caller.new(false)
      @contents, @data = @caller.call(
        {
          :method        => 'DOExpressCheckoutPayment',
          :token         => session[:token],
          :payerid       => session[:payerid],
          :amt           => session[:AMT].to_s,
          :currencycode  => session[:ccode],
          :paymentaction => "sale"
        }
      )    
	  	if Order.find(params[:id]).participant_id != current_user.participant_id
	  		flash[:error] = "Unauthorized"
	  		redirect_to :controller => '/home', :action => 'index'
	  	else
	      approve_order(params[:id])
	      
	      flash[:notice] = "Your transaction has completed successfully"
	      redirect_to :action => 'account_history'
	    end
    else
      flash[:error] = "Paypal Failed ACK = #{@response["ACK"]} Message = #{@response["L_LONGMESSAGE0"]}"
      cancel_order(params[:id])
      redirect_to :action => 'pending_items'
    end

    rescue Errno::ENOENT => exception
      cancel_order(params[:id])
      flash[:error] = "Your payment has been cancelled"
      redirect_to :action => 'pending_items'
  end

  def complete_authorize_net_payment
  	if Order.find(params[:id]).participant_id != current_user.participant_id
  		flash[:error] = "Unauthorized"
  		redirect_to :controller => '/home', :action => 'index'
  	else
	    approve_order(params[:id])
  	  flash[:notice] = "Your transaction has completed successfully"
    	redirect_to :action => 'account_history'
		end
  end

	def complete_nelix_payment
  	if Order.find(params[:id]).participant_id != current_user.participant_id
  		flash[:error] = "Unauthorized"
  		redirect_to :controller => '/home', :action => 'index'
  	elsif params[:responsetext] == "SUCCESS" || params[:responsetext] == "APPROVED"
	    approve_order(params[:id])
  	  flash[:notice] = "Your transaction has completed successfully"
    	redirect_to :action => 'account_history'
    else
      flash[:error] = "Nelix Payment Failed Response = #{params["responsetext"]}"
      cancel_order(params[:id])
      redirect_to :action => 'pending_items'
		end
	end
	
  def cancel_payment
    cancel_order(params[:id])
    flash[:error] = "Your payment has been cancelled"
    redirect_to :action => 'pending_items'
  end

  def restart_payment
    order = Order.find_by_id(params[:id])  
    line_items = order.line_items.find(:all)
    total_price = 0
    if !order.completed
      for line_item in line_items
        total_price += line_item.price
      end
      session[:AMT] = total_price
      if order.payment_type_id == 3
        do_paypal_payment(order.id)
      elsif order.payment_type_id == 9
      	do_nelix_payment(order.id)
      else
        do_authorize_net_payment(order.id)
      end
    else
      flash[:warning] = 'Payment for this order already completed'
      redirect_to :action => 'account_history'
    end
  end

  def record_receipt
  	line_item = LineItem.find(params[:id])
  	if line_item.nil?
  		flash[:error] = "invalid line item"
  	elsif params[:google_receipt_number] == ""
  		flash[:error] = "please enter your receipt number"
  	else
  		line_item.google_receipt_number = params[:google_receipt_number]
  		LineItem.transaction do
	  		line_item.save!
  			flash[:notice] = "Your transaction has been updated"
  		end
  	end
  	redirect_to :action => 'pending_items'
  rescue ActiveRecord::RecordInvalid => e
  	flash[:error] = "There was an error with your receipt number"
  	redirect_to :action => 'pending_items'
  end
  
protected
	def calculate_total_charge
		total_charge = 0
		for item in @team_entries
			total_charge += item.price
		end
		for item in @roster_entries 
			total_charge += item.price
		end
		for item in @class_entries 
			total_charge += item.price
		end
		for item in @charges 
			total_charge += item.price
		end
		for item in @credits 
			total_charge = total_charge - item.price
		end
		return total_charge
	end

  def do_paypal_payment(id)
      @ECRedirectURL=PayPalSDKProfiles::Profile.PAYPAL_EC_URL 
      @cancelURL="http://" + $g_return_url + "/shopping_cart/cancel_payment/" + id.to_s
      @retrunURL= "http://" + $g_return_url + "/shopping_cart/complete_paypal_payment/" + id.to_s    
      session[:ccode]= "USD"      
      @caller =  PayPalSDKCallers::Caller.new(false)    
      @contents, @data = @caller.call(
        {
          :method         => 'SetExpressCheckout',
          :amt            => session[:AMT].to_s,
          :currencycode   => "USD",
          :paymentaction  => "sale",
          :no_shipping => 1,
          :cancelurl      => @cancelURL,
          :returnurl      => @retrunURL            
        }    
      )    
      @response = CGI::parse(@data)     
      @token= @response["TOKEN"].to_s
      session[:token] = @token
      if (@response["ACK"].to_s != "Failure") 
        redirect_to(@ECRedirectURL+@token)
      else
        flash[:error] = "Paypal Payment System Failed: #{@response["L_ERRORCODE0"]} - #{@response["L_LONGMESSAGE0"]}:#{@response["L_LONGMESSAGE0"]}.  Please contact the administrator."
        cancel_order(id)
        redirect_to :action => 'pending_items'
      end  
  end

  def do_nelix_payment(id)
      @retrunURL= "http://" + MasterSetting.find(1).return_url + "/shopping_cart/complete_nelix_payment/" + id.to_s
      redirect_string =   {

      		:return_method => "redirect", 
					:customer_receipt => "true",
					:action => "process_fixed",
					:key_id =>  PaymentSetting.find(1).nelix_user_name,
					:return_link => @retrunURL,
					:order_description => "#{MasterSetting.find(1).system_name} Purchase",
					:shipping => "fixed|0.00",
					:amount => session[:AMT].to_s,
					:first_name => current_user.participant.first_name,
					:last_name => current_user.participant.last_name,
					:address_1 => current_user.participant.address_line_1,
					:address_2 => current_user.participant.address_line_2,
					:city => current_user.participant.city,
					:state => current_user.participant.state,
					:postal_code => current_user.participant.zip,
					:phone => current_user.participant.phone,
					:email => current_user.participant.email,
					:country => 'US'
        }    
      redirect_to(URI.escape("https://secure.networkmerchants.com/cart/cart.php?#{hash2cgiString(redirect_string)}"))
  end

  def do_authorize_net_payment(id)
      @cancelURL="http://" + $g_return_url + "/shopping_cart/cancel_payment/" + id.to_s
      @retrunURL= "http://" + $g_return_url + "/shopping_cart/complete_authorize_net_payment/" + id.to_s    
      redirect_string =   {
          :amt            => session[:AMT].to_s,
          :cancelurl      => @cancelURL,
          :returnurl      => @retrunURL,
          :fname => current_user.participant.first_name,
          :lname => current_user.participant.last_name,
          :address => current_user.participant.address_line_1,
          :city => current_user.participant.city,
          :state => current_user.participant.state,
          :zip => current_user.participant.zip,
          :email => current_user.participant.email,
          :phone => current_user.participant.phone,
          :order => id,
          :cid => MasterSetting.find(1).customer_id
        }    
        redirect_to(URI.escape("https://sharedsll.e-nethost.com/smartpricetravel-com/facilitrax/begin_payment.asp?#{hash2cgiString(redirect_string)}"))
  end
  
  def hash2cgiString(h)
    h.map { |a| a.join('=') }.join('&') 
  end
end
