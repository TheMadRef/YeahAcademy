class RtUserGroup < ActiveRecord::Base
  belongs_to :rt_user_group_type  
  has_many :rt_user_group_sport_relationships, :dependent => :destroy
  has_many :rt_participant_user_group_relationships, :dependent => :destroy
  has_many :rt_participant_team_relationships, :dependent => :destroy
  has_many :rt_employee_titles, :dependent => :destroy
  has_many :rt_memo_user_group_relationships, :dependent => :destroy
  validates_presence_of :user_group_name, :rt_user_group_type_id
  validates_uniqueness_of :user_group_name
  
	def self.power_sports_for_participant(participant_id)
		return ImSport.find(:all, :select => "DISTINCT im_sports.*", :joins => "INNER JOIN rt_user_group_sport_relationships ON im_sports.id = rt_user_group_sport_relationships.im_sport_id INNER JOIN rt_participant_user_group_relationships ON rt_user_group_sport_relationships.rt_user_group_id = rt_participant_user_group_relationships.rt_user_group_id INNER JOIN rt_user_groups ON rt_user_groups.id = rt_participant_user_group_relationships.rt_user_group_id", :conditions => ["rt_participant_user_group_relationships.participant_id = ? AND rt_user_groups.rt_user_group_type_id = ?", participant_id, 3])
	end
end
