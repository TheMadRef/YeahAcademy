class CreateParticipantMemberships < ActiveRecord::Migration
  def self.up
    create_table :participant_memberships do |t|
    	t.column :participant_id, :integer
    	t.column :participant_contract_id, :integer
    	t.column :start_date_time, :datetime
    	t.column :end_date_time, :datetime
    	t.column :number_of_entries, :integer
    	t.column :entries_remaining, :integer
    	t.column :paid, :boolean
    	t.column :receipt_number, :integer
    end
  end

  def self.down
    drop_table :participant_memberships
  end
end
