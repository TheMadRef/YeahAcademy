class AddTermDefaultLateDateColumn < ActiveRecord::Migration
  def self.up
    add_column :terms, :default_class_price, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :terms, :default_class_roster_maximum, :integer, :default => 99
    add_column :terms, :default_class_late_date, :datetime
    add_column :terms, :default_class_late_price, :decimal, :precision => 8, :scale => 2, :default => 0
  end

  def self.down
    remove_column :terms, :default_class_price
    remove_column :terms, :default_class_roster_maximum
    remove_column :terms, :default_class_late_date
    remove_column :terms, :default_class_late_price
  end
end
