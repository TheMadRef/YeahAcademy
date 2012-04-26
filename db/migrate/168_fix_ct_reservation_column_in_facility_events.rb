class FixCtReservationColumnInFacilityEvents < ActiveRecord::Migration
  def self.up
  	rename_column :facility_events, :ct_session_id, :ct_reservation_id
  end

  def self.down
  	rename_column :facility_events, :ct_reservation_id, :ct_session_id
  end
end
