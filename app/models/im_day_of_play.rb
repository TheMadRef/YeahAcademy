class ImDayOfPlay < ActiveRecord::Base
  has_many :im_divisions, :order => "division_name", :dependent => :destroy
  has_many :im_dop_dates, :dependent => :destroy
  belongs_to :im_sport
  
  validates_presence_of :dop_name, :im_sport_id
  validates_uniqueness_of :dop_name, :scope => :im_sport_id, :case_sensitive => false

  def self.find_dop_by_im_sport_id(im_sport_id)
    find(:all, :conditions => ["im_sport_id = ?", im_sport_id])
  end
end
