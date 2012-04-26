class CreateImDivisions < ActiveRecord::Migration
  def self.up
    create_table :im_divisions do |t|
      t.column :im_league_id, :integer
      t.column :im_day_of_play_id, :integer
      t.column :division_name, :string
      t.column :number_of_teams, :integer
      t.column :start_time, :time
      t.column :end_time, :time
      t.column :rotating, :boolean
      t.column :imtrack_id, :integer
    end
  end

  def self.down
    drop_table :im_divisions
  end
end
