class AddCtParticipantColumns < ActiveRecord::Migration
  def self.up
    add_column :participants, :ct_terms_and_conditions, :boolean, :default => false
    add_column :ct_rosters, :terms_and_conditions, :boolean, :default => false
    add_column :participants, :ct_active, :boolean, :default => false
  end

  def self.down
    remove_column :participants, :ct_terms_and_conditions
    remove_column :ct_rosters, :terms_and_conditions
    remove_column :participants, :ct_active
  end
end
