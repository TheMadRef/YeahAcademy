class ReservationRecurrence < ActiveRecord::Base
	belongs_to :reservation
	has_many :reservation_recurrence_dates, :dependent => :destroy
end
