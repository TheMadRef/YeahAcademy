class CreateImSports < ActiveRecord::Migration
  def self.up
    create_table :im_sports do |t|
      t.column :term_id, :integer
      t.column :sport_name, :string
      t.column :start_date, :datetime
      t.column :end_date, :datetime
      t.column :roster_end_date, :datetime
      t.column :require_color, :boolean
      t.column :price, :decimal, :precision => 8, :scale => 2, :default => 0
      t.column :roster_minimum, :integer, :default => 1
      t.column :roster_maximum, :integer, :default => 99
      t.column :imtrack_id, :integer      
    end
  end

  def self.down
    drop_table :im_sports
  end
end
