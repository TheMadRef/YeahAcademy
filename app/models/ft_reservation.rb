class FtReservation < ActiveRecord::Base
  has_one :facility_event, :dependent => :destroy
	belongs_to :playing_area
	belongs_to :participant
  has_many :ft_reservation_recurrence	
end
