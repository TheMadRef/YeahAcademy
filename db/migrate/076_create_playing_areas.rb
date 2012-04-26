class CreatePlayingAreas < ActiveRecord::Migration
  def self.up
    create_table :playing_areas do |t|
      t.column :facility_id, :integer
      t.column :playing_area_name, :string
      t.column :abbreviation, :string
      t.column :parent_id, :integer, :default => 0
    end
  end

  def self.down
    drop_table :playing_areas
  end
end
