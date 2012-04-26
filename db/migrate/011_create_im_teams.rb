class CreateImTeams < ActiveRecord::Migration
  def self.up
    create_table :im_teams do |t|
      t.column :im_division_id, :integer
      t.column :im_league_id, :integer
      t.column :team_name, :string
      t.column :team_number, :integer
      t.column :im_color_id, :integer
      t.column :approved, :boolean
      t.column :password, :string
      t.column :comment, :text
      t.column :imtrack_id, :integer
    end
  end

  def self.down
    drop_table :im_teams
  end
end
