class RtJoinRequest < ActiveRecord::Base
  belongs_to :participant
  
  validates_uniqueness_of :participant_id, :message => "Only one request per participant allowed", :allow_nil => false 

end
