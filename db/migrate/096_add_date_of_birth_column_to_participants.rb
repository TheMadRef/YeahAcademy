class AddDateOfBirthColumnToParticipants < ActiveRecord::Migration
  def self.up
  	add_column :participants, :DOB, :date, :default => (Time.now - 60*60*24*365*18)
  end

  def self.down
  	remove_column :participants, :DOB
  end
end
