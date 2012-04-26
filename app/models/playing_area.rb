class PlayingArea < ActiveRecord::Base
  belongs_to :facility
  belongs_to :playing_area, :foreign_key => "parent_id"
  has_many :im_teams, :dependent => :nullify
  has_many :im_games, :dependent => :nullify
  has_many :ft_reservations, :dependent => :nullify
  has_many :ct_session_schedules, :dependent => :nullify
     
  validates_presence_of :playing_area_name, :area_abbreviation, :facility_id
  validates_uniqueness_of :playing_area_name, :scope => [:facility_id]

  def validate
    #validating parent_id
    if not parent_id.nil?    
      errors.add(:parent_id, "should be zero or greater" ) if parent_id < 0
    else
      parent_id = 0
    end
  end  

  def self.sorted_playing_area_array(facility_id)
    array = []
    if facility_id == 0
      playing_areas_for_array = find(:all, :conditions => ["parent_id = ?", 0], :order => "facility_id ASC, playing_area_name ASC")
    else
      playing_areas_for_array = find(:all, :conditions => ["facility_id = ? AND parent_id = ?", facility_id, 0], :order => "facility_name ASC")
    end
    for playing_area in playing_areas_for_array
      array << playing_area.id
      sub_playing_areas_for_array = find(:all, :conditions => ["parent_id = ?", playing_area.id], :order => "facility_id ASC, playing_area_name ASC")
      if !sub_playing_areas_for_array.nil?
        for sub_playing_area in sub_playing_areas_for_array
          array << sub_playing_area.id
        end
      end
    end
    return array
  end
  
  def self.sorted_playing_area_for_select(facility_id)
    playing_area_list = []
    if facility_id == 0
      playing_areas_for_select = find(:all, :conditions => ["parent_id = ?", 0], :order => "facility_id ASC, playing_area_name ASC")
    else
      playing_areas_for_select = find(:all, :conditions => ["facility_id = ? AND parent_id = ?", facility_id, 0], :order => "facility_name ASC")
    end
    for playing_area in playing_areas_for_select
      playing_area_list << ["#{playing_area.facility.facility_name}:#{playing_area.playing_area_name}", playing_area.id]
      sub_playing_areas_for_select = find(:all, :conditions => ["parent_id = ?", playing_area.id], :order => "facility_id ASC, playing_area_name ASC")
      if !sub_playing_areas_for_select.nil?
        for sub_playing_area in sub_playing_areas_for_select
          playing_area_list << ["#{playing_area.facility.facility_name}:#{playing_area.playing_area_name}:#{sub_playing_area.playing_area_name}", sub_playing_area.id]
        end
      end
    end
    return playing_area_list
  end


end
