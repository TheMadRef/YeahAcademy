class CreateCtClasses < ActiveRecord::Migration
  def self.up
    create_table :ct_classes do |t|
      t.column :term_id, :integer
      t.column :class_name, :string
      t.column :abbreviation, :string
      t.column :registration_start, :datetime
      t.column :registration_end, :datetime
      t.column :default_roster_maximum, :integer, :default => 99
      t.column :default_price, :decimal, :precision => 8, :scale => 2, :default => 0
      t.column :default_late_date, :datetime
      t.column :default_late_price, :decimal, :precision => 8, :scale => 2, :default => 0
      t.column :comment, :text
      t.column :class_track_id, :integer
    end
  end

  def self.down
    drop_table :ct_classes
  end
end
