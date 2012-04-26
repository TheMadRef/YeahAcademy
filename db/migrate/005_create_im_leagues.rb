class CreateImLeagues < ActiveRecord::Migration
  def self.up
    create_table :im_leagues do |t|
      t.column :im_sport_id, :integer
      t.column :parent_id, :integer, :default => 0
      t.column :league_name, :string
      t.column :max_allowed, :integer
      t.column :comment, :text
      t.column :imtrack_id, :integer
    end
  end

  def self.down
    drop_table :im_leagues
  end
end
