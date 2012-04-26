class CreateImRosters < ActiveRecord::Migration
  def self.up
    create_table :im_rosters do |t|
      t.column :im_team_id, :integer
      t.column :participant_id, :integer
      t.column :captain, :boolean
      t.column :im_track_id, :boolean
    end
  end

  def self.down
    drop_table :im_rosters
  end
end
