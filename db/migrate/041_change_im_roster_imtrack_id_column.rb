class ChangeImRosterImtrackIdColumn < ActiveRecord::Migration
  def self.up
    change_column :im_rosters, :im_track_id, :integer
  end

  def self.down
  end
end
