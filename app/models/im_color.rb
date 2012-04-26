class ImColor < ActiveRecord::Base
  has_many :im_teams

  validates_presence_of :color_name
  validates_uniqueness_of :color_name
end
