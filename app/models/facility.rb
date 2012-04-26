class Facility < ActiveRecord::Base
  has_many :playing_areas, :dependent => :destroy
  has_many :rt_participant_facility_blocks, :dependent => :destroy
  has_many :facility_time_frames, :dependent => :destroy

  validates_presence_of :facility_name
  validates_uniqueness_of :facility_name
  
end
