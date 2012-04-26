class CreateCtReservations < ActiveRecord::Migration
  def self.up
    create_table :ct_reservations do |t|
    	t.column :ct_session_schedule_id, :integer
    	t.column :session_date, :date
    	t.column :start_time, :time
    	t.column :end_time, :time
    	t.column :playing_area_id, :integer
    end
  end

  def self.down
    drop_table :ct_reservations
  end
end
