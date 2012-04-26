class FtReservationRecurrence < ActiveRecord::Base
	has_and_belongs_to :ft_reservation
	has_many :ft_reservation_recurrence_dates, :dependent => :destroy
end
