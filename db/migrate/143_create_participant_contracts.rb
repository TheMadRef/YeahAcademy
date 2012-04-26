class CreateParticipantContracts < ActiveRecord::Migration
  def self.up
    create_table :participant_contracts do |t|
    	t.column :contract_name, :string
    	t.column :date_type, :integer
    	t.column :start_date, :datetime
    	t.column :end_date, :datetime
    	t.column :length, :integer
    	t.column :length_unit, :integer
    	t.column :block_pass, :boolean
    	t.column :number_of_entries, :integer
    	t.column :day_time_access, :boolean
    	t.column :time_range, :integer
    	t.column :day, :integer
    	t.column :start_time, :datetime
    	t.column :end_time, :datetime
    	t.column :off_peak, :boolean
    end
  end

  def self.down
    drop_table :participant_contracts
  end
end
