class CreateParticipantEvents < ActiveRecord::Migration
  def self.up
    create_table :participant_events do |t|
    	t.column :participant_id, :integer
    	t.column :ct_reservation_id, :integer
    end
  end

  def self.down
    drop_table :participant_events
  end
end
