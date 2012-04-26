class Order < ActiveRecord::Base
  has_many :line_items
  belongs_to :payment_type
  belongs_to :participant
  
  after_save :update_participant_fees

  def self.sorted_order_array(start_date, end_date, payment_item_id, participant_id)
    array = []
    if participant_id.blank?
      if payment_item_id.blank?
      	orders_for_array = find(:all, :conditions => ["created_at >= ? AND created_at <= ? AND completed = ?", start_date, end_date, 1], :order => "created_at, participant_id")
      else
      	orders_for_array = find(:all, :select => "DISTINCT orders.*", :joins => " INNER JOIN line_items ON line_items.order_id = orders.id",  :conditions => ["orders.created_at >= ? AND orders.created_at <= ? AND line_items.payment_item_id = ? AND completed = ?", start_date, end_date, payment_item_id, 1], :order => "created_at, participant_id")
      end
    else
      if payment_item_id.blank?
      	orders_for_array = find(:all, :conditions => ["created_at >= ? AND created_at <= ? AND participant_id = ? AND completed = ?", start_date, end_date, participant_id, 1], :order => "created_at")
      else
      	orders_for_array = find(:all, :select => "DISTINCT orders.*", :joins => " INNER JOIN line_items ON line_items.order_id = orders.id", :conditions => ["orders.created_at >= ? AND orders.created_at <= ? AND line_items.payment_item_id = ? AND orders.participant_id = ? AND completed = ?", start_date, end_date, payment_item_id, participant_id, 1], :order => "created_at")
      end
    end
    if !orders_for_array[0].nil?
      for order in orders_for_array
        array << order.id
      end
    end
    return array
  end
  
  protected
  	def update_participant_fees
  		if self.completed
  			$g_admin = true
  			if !self.line_items.find(:first, :conditions => ["payment_item_id = ?", 6]).nil?
  				self.participant.paid_application_fee = true
  				self.participant.save
  			end
  			if !self.line_items.find(:first, :conditions => ["payment_item_id = ?", 7]).nil?
  				self.participant.paid_membership_fee = true
  				self.participant.save
  			end
  			$g_admin = false
  		end
  	end
end
