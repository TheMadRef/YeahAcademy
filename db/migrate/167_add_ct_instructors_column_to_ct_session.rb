class AddCtInstructorsColumnToCtSession < ActiveRecord::Migration
  def self.up
  	add_column :ct_sessions, :ct_instructor_id, :integer
  end

  def self.down
  	remove_column :ct_sessions, :ct_instructor_id
  end
end
