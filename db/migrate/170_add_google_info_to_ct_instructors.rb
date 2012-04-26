class AddGoogleInfoToCtInstructors < ActiveRecord::Migration
  def self.up
  	add_column :ct_instructors, :google_account, :string
  end

  def self.down
  	remove_column :ct_instructors, :google_account
  end
end
