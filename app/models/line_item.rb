class LineItem < ActiveRecord::Base
  belongs_to :participant
  belongs_to :order
  belongs_to :payment_item
  belongs_to :im_roster
  belongs_to :ct_roster
  belongs_to :im_team
  belongs_to :discount_log
  belongs_to :fee_log

  validates_presence_of :participant_id, :message => "does not exist.  Invalid Participant."  
  validates_presence_of :payment_item_id, :message => "must have a payment item"    
  validates_uniqueness_of :ct_roster_id, :message => "a duplicate payment for this class session has been detected", :allow_nil => true
  validates_uniqueness_of :im_roster_id, :message => "a duplicate payment for this roster entry has been detected", :allow_nil => true
  validates_uniqueness_of :im_team_id, :message => "a duplicate payment for this team entry has been detected", :allow_nil => true
  validates_uniqueness_of :discount_log_id, :message => "a duplicate entry for this discount/credit has been detected", :allow_nil => true
  validates_uniqueness_of :fee_log_id, :message => "a duplicate entry for this fee/charge has been detected", :allow_nil => true
  validates_uniqueness_of :google_receipt_number, :message => "invalid receipt number", :if => :require_google_receipt_number?
  validates_length_of :google_receipt_number, :within => 15..15, :if => :require_google_receipt_number?

  def self.sorted_line_item_array(start_date, end_date, payment_item_id, participant_id)
    array = []
    if participant_id.blank?
      if payment_item_id.blank?
      	line_items_for_array = find(:all, :conditions => ["payment_due_date >= ? AND payment_due_date <= ? AND order_id IS NULL", start_date, end_date], :order => "payment_due_date, participant_id")
      else
      	line_items_for_array = find(:all, :conditions => ["payment_due_date >= ? AND payment_due_date <= ? AND payment_item_id = ? AND order_id IS NULL", start_date, end_date, payment_item_id], :order => "payment_due_date, participant_id")
      end
    else
      if payment_item_id.blank?
      	line_items_for_array = find(:all, :conditions => ["payment_due_date >= ? AND payment_due_date <= ? AND participant_id = ? AND order_id IS NULL", start_date, end_date, participant_id], :order => "payment_due_date, payment_item_id")
      else
      	line_items_for_array = find(:all, :conditions => ["payment_due_date >= ? AND payment_due_date <= ? AND payment_item_id = ? AND participant_id = ? AND order_id IS NULL", start_date, end_date, payment_item_id, participant_id], :order => "payment_due_date, payment_item_id")
      end
    end
    if !line_items_for_array[0].nil?
      for line_item in line_items_for_array
        array << line_item.id
      end
    end
    return array
  end
  
  protected 
  	def require_google_receipt_number?
  		!self.google_receipt_number.nil?
  	end		
end
