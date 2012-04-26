class CreateCtInstructors < ActiveRecord::Migration
  def self.up
    create_table :ct_instructors do |t|
    	t.column :participant_id, :integer
    end
  end

  def self.down
    drop_table :ct_instructors
  end
end
