require 'digest/sha1'
class User < ActiveRecord::Base
  belongs_to :participant

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login, :case_sensitive => false
  validates_uniqueness_of   :participant_id, :allow_nil => :admin_account?
  
  before_save :encrypt_password

  def validate
    if $g_master_terms_and_conditions && !admin
      errors.add(:terms_and_conditions, "must be accepted") if !participant.terms_and_conditions
    end
    if $g_master_im_terms_and_conditions && !admin
      errors.add(:im_terms_and_conditions, "must be accepted") if !participant.im_terms_and_conditions
    end
    if $g_master_ct_terms_and_conditions && !admin
      errors.add(:ct_terms_and_conditions, "must be accepted") if !participant.ct_terms_and_conditions
    end
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # The se create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{login}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def self.is_user_admin?
    if current_user.admin
      return true
    else
      return false
    end
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end

    def admin_account?
      admin?
    end
 end
