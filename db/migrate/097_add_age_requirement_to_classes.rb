class AddAgeRequirementToClasses < ActiveRecord::Migration
  def self.up
		add_column :terms, :default_class_minimum_age, :integer, :default => 1
		add_column :terms, :default_class_maximum_age, :integer, :default => 99
		add_column :ct_classes, :default_minimum_age, :integer, :defaault => 1
		add_column :ct_classes, :default_maximum_age, :integer, :default => 99
		add_column :ct_sessions, :s_minimum_age, :integer, :default => 1
		add_column :ct_sessions, :s_maximum_age, :integer, :default => 99
  end

  def self.down
  	remove_column :terms, :default_class_minimum_age
  	remove_column :terms, :default_class_maximum_age
  	remove_column :ct_classes, :default_minimum_age
  	remove_column :ct_classes, :default_maximum_age
  	remove_column :ct_sessions, :s_minimum_age
  	remove_column :ct_sessions, :s_maximum_age
  end
end
