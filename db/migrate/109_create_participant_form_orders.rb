class CreateParticipantFormOrders < ActiveRecord::Migration
  def self.up
    create_table :participant_form_orders do |t|
    	t.column :participant_column_human_name, :string
    	t.column :participant_column_name, :string
    	t.column :participant_column_required, :boolean
    	t.column :participant_custom_field_id, :integer
    	t.column :sort_number, :integer
    	t.column :show_field, :boolean, :default => true
			t.column :participant_column_type, :string, :default => "text"
    end
  end

  def self.down
    drop_table :participant_form_orders
  end
end
