require 'digest/sha1'
class Participant < ActiveRecord::Base
	belongs_to :category
  belongs_to :participant, :foreign_key => "parent_id"
  belongs_to :participant_title
  has_many :ct_rosters, :dependent => :destroy
  has_one :ct_instructor, :dependent => :destroy
  has_many :im_rosters, :dependent => :destroy
  has_many :im_free_agents, :dependent => :destroy
  has_many :line_items
  has_many :orders
  has_many :discount_logs
  has_many :fee_logs
  has_many :rt_participant_user_group_relationships, :dependent => :destroy
  has_many :rt_participant_team_relationships, :dependent => :destroy
  has_many :rt_participant_facility_blocks, :dependent => :destroy
  has_many :rt_participant_team_blocks, :dependent => :destroy
  has_many :rt_participant_out_dates, :dependent => :destroy
  has_many :rt_employee_schedules, :dependent => :nullify
  has_many :rt_employee_calendars, :dependent => :destroy 
  has_many :rt_employee_turnbacks, :dependent => :destroy 
  has_many :participants, :foreign_key => "parent_id", :dependent => :nullify
  has_many :participant_custom_field_entries, :dependent => :destroy
  has_many :participant_memberships, :dependent => :destroy 
  has_many :holds, :dependent => :destroy
  has_many :ft_reservations, :dependent => :nullify
  has_one :user, :dependent => :destroy
  has_one :im_captain_card, :dependent => :destroy
  has_one :rt_join_request, :dependent => :destroy
  
  # Virtual attribute for the unencrypted member_id
  attr_accessor :participant_number, :parent_participant_number, :email_confirmation, :custom_field_values
  
  validates_presence_of :participant_number, :if => :participant_number_required?
  validates_presence_of :first_name, :last_name
  validates_presence_of :email, :if => :email_required?
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
	validates_presence_of :phone, :if => :phone_required?
  validates_presence_of :category_id, :if => :category_required?
  validates_presence_of :address_line_1, :city, :state, :zip, :if => :address_required?
#  validates_presence_of :yeah_code # uncomment when ready
  validates_uniqueness_of :member_id
  
  before_save :encrypt_participant_number
  after_create :add_application_and_membership_fee

  def validate
    #Since member id is nil during validation, we will do a manual validation to make sure member id is unique
    if !participant_number.blank?
      errors.add(:participant_number, "already in database") if !Participant.find_by_participant_number(participant_number).nil?
    end

		#validate parent id number if entered
		if !parent_participant_number.blank?
			if Participant.find_by_participant_number(parent_participant_number).nil?
  			errors.add(:parent_participant_number, " was not found in the database")
  		else
  			self.parent_id = Participant.find_by_participant_number(parent_participant_number).id
  		end
		else
			if !parent_id.nil?
				errors.add(:participant_number, "must have valid head of household status")	if parent_id < 0
			else
				parent_id = 0
			end
		end

		#Validate user confirming email address
		if !email_confirmation.nil? && !email_confirmation.blank?
			errors.add(:email, " does not match email confirmation") if email_confirmation != email
		end
		
		#validate custom fields
		custom_fields = ParticipantCustomField.find(:all)
		for custom_field in custom_fields
			if custom_field.required? && !$g_admin
				errors.add(:custom_field_values, " must have a valid #{custom_field.field_name}") if custom_field_values[custom_field.id].blank?
			end
		end
	end
    
  def self.find_by_participant_number(participant_number)
    return nil if participant_number.nil? || participant_number == ""
    find_by_member_id(encrypt_member_id(participant_number))
  end
  
  def self.encrypt_member_id(participant_number)
    # hard code salt for now
    Digest::SHA1.hexdigest("--facilitraxisgod--#{participant_number}--")
  end

	def self.print_gender(participant_id)
		if self.find_by_id(participant_id).gender?
			return "female"
		else
			return "male"
		end
	end

  def self.participant_field_value(column, roster)
	  if column.participant_column_name == "gender"
			return (roster.participant.gender? ? "Female" : "Male")
	  elsif column.participant_custom_field.nil?
			if column.participant_column_name != "category_id"
				return eval("roster.participant.#{column.participant_column_name}")
			else
			  return (roster.participant.category.nil? ? "N/A" : roster.participant.category.category_name)
			end
		else 
			custom_field = ParticipantCustomFieldEntry.find(:first, :conditions => ["participant_id = ? AND participant_custom_field_id = ?", roster.participant_id, column.participant_custom_field_id])
			return (custom_field.nil? ? "N/A" : custom_field.field_data)
		end
  end
	
  protected
    # before filter 
    def encrypt_participant_number
      return if participant_number.blank?
      self.member_id = self.class.encrypt_member_id(participant_number)
    end
		  	
    def participant_number_required?
      member_id.blank? || !participant_number.blank?
    end    
    
    def email_required?
      !$g_admin && !$g_require_member_number
    end
    
    def address_required?
      $g_require_address && !$g_admin
    end
    
    def phone_required?
      $g_require_phone_number && !$g_admin
    end

    def category_required?
      $g_require_category && !$g_admin
    end
    
    def add_application_and_membership_fee
    	if MasterSetting.find(1).require_membership_fee && self.parent_id == 0
    		application_fee = MasterSetting.find(1).application_fee
    		membership_fee = MasterSetting.find(1).membership_fee
	    	if application_fee > 0
	    		line_item = LineItem.new
	    		line_item.participant_id = self.id
	    		line_item.payment_item_id = 6
	    		line_item.price = application_fee
	    		line_item.comment = "One time application fee"
	    		line_item.payment_due_date = Time.now
	    		line_item.save!
	    	end
	    	if membership_fee > 0
	    		line_item = LineItem.new
	    		line_item.participant_id = self.id
	    		line_item.payment_item_id = 7
	    		line_item.price = membership_fee
	    		line_item.comment = "Yearly membership fee"
	    		line_item.payment_due_date = Time.now
	    		line_item.save!
	    	end
	    end
    end
end
