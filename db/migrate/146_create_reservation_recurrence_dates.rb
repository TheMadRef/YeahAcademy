class CreateReservationRecurrenceDates < ActiveRecord::Migration
  def self.up
    create_table :reservation_recurrence_dates do |t|
    	t.column :reservation_recurrence_id, :integer
    	t.column :recurrence_date, :datetime
    	t.column :recurrence_type, :integer
    end
  end

  def self.down
    drop_table :reservation_recurrence_dates
  end
end
