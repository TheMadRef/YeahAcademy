class CreateReservationRecurrences < ActiveRecord::Migration
  def self.up
    create_table :reservation_recurrences do |t|
    	t.column :reservation_id, :integer
    	t.column :start_time, :datetime
    	t.column :end_time, :datetime
    	t.column :pattern_selection, :integer
    	t.column :flag_1, :string
    	t.column :flag_2, :string
    	t.column :flag_3, :string
    	t.column :flag_4, :string
    	t.column :flag_5, :string
    	t.column :flag_6, :string
    	t.column :flag_7, :string
    	t.column :flag_8, :string
    	t.column :start_date, :datetime
    	t.column :end_selection, :integer
    	t.column :end_flag, :string
    end
  end

  def self.down
    drop_table :reservation_recurrences
  end
end
