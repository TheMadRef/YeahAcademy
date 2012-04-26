class TermAddClassTrackFields < ActiveRecord::Migration
  def self.up
    add_column :terms, :default_class_registration_start, :datetime
    add_column :terms, :default_class_registration_end, :datetime
  end

  def self.down
    remove_column :terms, :default_class_registration_start
    remove_column :terms, :default_class_registration_end
  end
end
