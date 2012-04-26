class CreateParticipantCustomFields < ActiveRecord::Migration
  def self.up
    create_table :participant_custom_fields do |t|
    	t.column :field_name, :string
    	t.column :sorting_number, :integer
    	t.column :required, :boolean, :default => false
    	t.column :inheritable, :boolean, :default => false
    end
  end

  def self.down
    drop_table :participant_custom_fields
  end
end
