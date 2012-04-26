class CreateRtParticipantFacilityBlocks < ActiveRecord::Migration
  def self.up
    create_table :rt_participant_facility_blocks do |t|
      t.column :participant_id, :integer
      t.column :facility_id, :integer
    end
  end

  def self.down
    drop_table :rt_participant_facility_blocks
  end
end
