class RtEmployeeTitleLeagueRelationship < ActiveRecord::Base
  belongs_to :im_league
  belongs_to :rt_employee_title
  belongs_to :rt_user_group
  
  validates_presence_of :im_league_id, :rt_employee_title_id, :rt_user_group_id
  validates_uniqueness_of :im_league_id, :scope => :rt_employee_title_id
end
