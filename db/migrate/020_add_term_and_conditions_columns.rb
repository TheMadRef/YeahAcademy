class AddTermAndConditionsColumns < ActiveRecord::Migration
  def self.up
    add_column :participants, :im_terms_and_conditions, :boolean, :default => false
    add_column :im_teams, :terms_and_conditions, :boolean, :default => false
    add_column :im_rosters, :terms_and_conditions, :boolean, :default => false
  end

  def self.down
    remove_column :participants, :im_terms_and_conditions
    remove_column :im_teams, :terms_and_conditions
    remove_column :im_rosters, :terms_and_conditions
  end
end
