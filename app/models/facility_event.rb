class FacilityEvent < ActiveRecord::Base
  belongs_to :im_game
  belongs_to :ft_reservation
  belongs_to :ct_reservation
end
