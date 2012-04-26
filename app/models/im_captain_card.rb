class ImCaptainCard < ActiveRecord::Base
  belongs_to :participant

  # Virtual attribute for the unencrypted password
  attr_accessor :basic_password
  attr_accessor :number_of_cards
  
  validates_presence_of :basic_password, :message => "can not be blank", :if => :password_required?
  validates_length_of :basic_password, :within => 6..16, :too_long => "the team password is longer than 16 characters", :too_short => "the team password should be at least 6 characters long", :if => :password_required?
  validates_uniqueness_of :participant_id, :message => "has a captain card assigned already", :allow_nil => true
  before_save :encrypt_basic_password

  def validate
    if !participant_id.nil?
      errors.add(:participant_id, "not eligible") if !participant.im_active
    end
  end

  def self.find_by_basic_password(basic_password)
    return nil if basic_password.nil? || basic_password == ""
    find_by_password(encrypt_password(basic_password))
  end
  
  def self.encrypt_password(basic_password)
    # hard code salt for now
    Digest::SHA1.hexdigest("--captaincardsrule--#{basic_password}--")
  end


  protected
    def self.new_password(len)
      chars = ("a".."k").to_a + ("m".."z").to_a + ("2".."9").to_a
      return Array.new(len){||chars[rand(chars.size)]}.join
    end

    # before filter 
    def encrypt_basic_password
      return if basic_password.blank?
      self.password = self.class.encrypt_password(basic_password)
    end

    def password_required?
      password.blank? || !basic_password.blank?
    end    
end
