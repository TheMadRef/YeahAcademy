class PaymentSetting < ActiveRecord::Base
  # Virtual attribute for the unencrypted member_id
  attr_accessor :new_paypal_user_name
  attr_accessor :new_paypal_password
  attr_accessor :new_paypal_signature
  attr_accessor :new_authorize_net_login
  attr_accessor :new_authorize_net_transaction_key
	attr_accessor :new_nelix_user_name
	  
  validates_presence_of :new_paypal_user_name, :if => :new_paypal_user_name_required?
  validates_presence_of :new_paypal_password, :if => :new_paypal_password_required?
  validates_presence_of :new_paypal_signature, :if => :new_paypal_signature_required?
  validates_presence_of :new_authorize_net_login, :if => :new_authorize_net_login_required?
  validates_presence_of :new_authorize_net_transaction_key, :if => :new_authorize_net_transaction_key_required?
  validates_presence_of :new_nelix_user_name, :if => :new_nelix_user_name_required?
    
  before_save :save_login_information
  
  protected
    # before filter 
    def save_login_information
      if !new_paypal_user_name.blank?
        self.paypal_api_user_name = new_paypal_user_name
      end
      if !new_paypal_password.blank?
        self.paypal_api_password = new_paypal_password
      end
      if !new_paypal_signature.blank?
        self.paypal_api_signature = new_paypal_signature
      end
      if !new_authorize_net_login.blank?
        self.authorize_net_login = new_authorize_net_login
      end
      if !new_authorize_net_transaction_key.blank?
        self.authorize_net_transaction_key = new_authorize_net_transaction_key
      end
      if !new_nelix_user_name.blank?
        self.nelix_user_name = new_nelix_user_name
      end
    end

    def new_paypal_user_name_required?
      paypal_api_user_name.blank? || !new_paypal_user_name.blank?
    end    

    def new_paypal_password_required?
      paypal_api_password.blank? || !new_paypal_password.blank?
    end    

    def new_paypal_signature_required?
      paypal_api_signature.blank? || !new_paypal_signature.blank?
    end    

    def new_authorize_net_login_required?
      authorize_net_login.blank? || !new_authorize_net_login.blank?
    end    

    def new_authorize_net_transaction_key_required?
      authorize_net_transaction_key.blank? || !new_authorize_net_transaction_key.blank?
    end    

    def new_nelix_user_name_required?
      nelix_user_name.blank? || !new_nelix_user_name.blank?
    end    
end
