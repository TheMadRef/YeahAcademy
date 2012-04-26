class CreateParticipantCustomFieldEntries < ActiveRecord::Migration
  def self.up
    create_table :participant_custom_field_entries do |t|
    	t.column :participant_id, :integer
    	t.column :participant_custom_field_id, :integer
    	t.column :field_data, :string
    end
  end

  def self.down
    drop_table :participant_custom_field_entries
  end
end
