class RtEmployeeTitle < ActiveRecord::Base
  has_many :rt_employee_title_league_relationships, :dependent => :destroy
  has_many :rt_employee_schedules, :dependent => :destroy
  belongs_to :im_sport
  belongs_to :rt_user_group
  
  validates_presence_of :employee_title, :abbreviation, :sorting_order, :im_sport_id
  validates_uniqueness_of :employee_title, :scope => :im_sport_id, :message => "has already been added for this sport"
  validates_uniqueness_of :sorting_order, :scope => :im_sport_id, :message => "has already been used for this sport"
  validates_numericality_of :sorting_order, :allow_nil => false, :only_integer => true
end
