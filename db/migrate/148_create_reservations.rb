class CreateReservations < ActiveRecord::Migration
  def self.up
    create_table :reservations do |t|
    	t.column :playing_area_id, :integer
    	t.column :participant_id, :integer
    	t.column :start_date_time, :datetime
    	t.column :end_date_time, :datetime
    	t.column :all_day, :boolean
    	t.column :description, :text
    	t.column :ft_facility_contract_id, :integer
    	t.column :price, :decimal, :precision => 8, :scale => 2
    	t.column :paid, :boolean
    	t.column :receipt_number, :integer
    	t.column :purchase_number, :integer
    	t.column :whole_facility, :boolean
    	t.column :reservation_recurrence_id, :integer
    	t.column :recurrence_sequence_number, :integer
    	t.column :added_by, :string
    end
  end

  def self.down
    drop_table :reservations
  end
end
