class AddMasterSettingsColumns < ActiveRecord::Migration
  def self.up
    add_column :participants, :terms_and_conditions, :boolean, :default => false
  end

  def self.down
    remove_column :participants, :terms_and_conditions
  end
end
