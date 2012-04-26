class CreateFacilityTimeFrames < ActiveRecord::Migration
  def self.up
    create_table :facility_time_frames do |t|
    	t.column :facility_id, :integer
    	t.column :day_number, :integer
    	t.column :start_time, :datetime
    	t.column :end_time, :datetime
    	t.column :off_peak, :boolean
    end
  end

  def self.down
    drop_table :facility_time_frames
  end
end
