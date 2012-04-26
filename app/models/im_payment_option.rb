class ImPaymentOption < ActiveRecord::Base
  belongs_to :im_settings
  has_many :im_teams
end
