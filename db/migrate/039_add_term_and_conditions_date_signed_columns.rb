class AddTermAndConditionsDateSignedColumns < ActiveRecord::Migration
  def self.up
    add_column :participants, :im_terms_and_conditions_timestamp, :datetime
    add_column :im_teams, :terms_and_conditions_timestamp, :datetime
    add_column :im_rosters, :terms_and_conditions_timestamp, :datetime
    add_column :participants, :terms_and_conditions_timestamp, :datetime
    add_column :participants, :ct_terms_and_conditions_timestamp, :datetime
    add_column :ct_rosters, :terms_and_conditions_timestamp, :datetime
  end

  def self.down
    remove_column :participants, :ct_terms_and_conditions_timestamp
    remove_column :ct_rosters, :terms_and_conditions_timestamp
    remove_column :participants, :terms_and_conditions_timestamp
    remove_column :participants, :im_terms_and_conditions_timestamp
    remove_column :im_teams, :terms_and_conditions_timestamp
    remove_column :im_rosters, :terms_and_conditions_timestamp
  end
end
