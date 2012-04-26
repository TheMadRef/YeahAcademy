class AddReftrackParticipantColumn < ActiveRecord::Migration
  def self.up
    add_column :participants, :rt_terms_and_conditions, :boolean, :default => false
    add_column :participants, :rt_active, :boolean, :default => false
  end

  def self.down
    remove_column :participants, :rt_terms_and_conditions
    remove_column :participants, :rt_active
  end
end
