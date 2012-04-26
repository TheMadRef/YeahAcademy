class CreateCtSessions < ActiveRecord::Migration
  def self.up
    create_table :ct_sessions do |t|
      t.column :ct_class_id, :integer
      t.column :s_class_name, :string
      t.column :s_abbreviation, :string
      t.column :s_all_bundle, :boolean
      t.column :s_registration_start, :datetime
      t.column :s_registration_end, :datetime
      t.column :s_roster_maximum, :integer, :default => 99
      t.column :s_price, :decimal, :precision => 8, :scale => 2, :default => 0
      t.column :s_late_date, :datetime
      t.column :s_late_price, :decimal, :precision => 8, :scale => 2, :default => 0
      t.column :s_comment, :text
      t.column :class_track_id, :integer
    end
  end

  def self.down
    drop_table :ct_sessions
  end
end
