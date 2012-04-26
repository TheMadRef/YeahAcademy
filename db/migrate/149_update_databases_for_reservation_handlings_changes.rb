class UpdateDatabasesForReservationHandlingsChanges < ActiveRecord::Migration
  def self.up
  	add_column :facility_events, :ct_session_id, :integer
  	rename_table :reservation_recurrences, :ft_reservation_recurrences
  	rename_table :reservation_recurrence_dates, :ft_reservation_recurrence_dates
  	drop_table :ft_reservations
  	rename_table :reservations, :ft_reservations
  end

  def self.down
  	remove_column :facility_events, :ct_session_id
  	rename_table :ft_reservation_recurrences, :reservation_recurrences
  	rename_table :ft_reservation_recurrence_dates, :reservation_recurrence_dates
		rename_table :ft_reservations, :reservations
    create_table :ft_reservations do |t|
    end  	
  end
end
