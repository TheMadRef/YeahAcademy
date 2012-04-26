class CreateImGames < ActiveRecord::Migration
  def self.up
    create_table :im_games do |t|
      t.column :parent_id, :integer, :default => 0
      t.column :game_set, :integer
      t.column :game_number, :integer
      t.column :match_up, :string
      t.column :im_league_id, :integer
      t.column :home_team_id, :integer
      t.column :visiting_team_id, :integer
      t.column :home_seed, :integer
      t.column :away_seed, :integer
      t.column :game_date, :date
      t.column :start_time, :time
      t.column :end_time, :time
      t.column :playing_area_id, :integer
      t.column :played, :boolean, :default => false
      t.column :home_score, :integer
      t.column :away_score, :integer
      t.column :number_sets, :integer
      t.column :home_set_1, :integer
      t.column :away_set_1, :integer
      t.column :home_set_2, :integer
      t.column :away_set_2, :integer
      t.column :home_set_3, :integer
      t.column :away_set_3, :integer
      t.column :home_set_4, :integer
      t.column :away_set_4, :integer
      t.column :home_set_5, :integer
      t.column :away_set_5, :integer
      t.column :home_sr, :decimal, :precision => 5, :scale => 2
      t.column :away_sr,  :decimal, :precision => 5, :scale => 2
      t.column :result, :string
      t.column :playoff, :boolean, :default => false
      t.column :home_high, :boolean, :default => false
      t.column :next_playoff_game, :string
      t.column :next_playoff_game_l, :string
      t.column :comment, :text
    end
  end

  def self.down
    drop_table :im_games
  end
end
