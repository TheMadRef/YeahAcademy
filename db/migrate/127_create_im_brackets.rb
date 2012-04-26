class CreateImBrackets < ActiveRecord::Migration
  def self.up
    create_table :im_brackets do |t|
    	t.column :im_sport_id, :integer
    	t.column :bracket_name, :string
    	t.column :bracket_abbreviation, :string
    	t.column :im_league_id, :integer
    	t.column :number_of_teams, :integer
    	t.column :double_elimination, :boolean
    	t.column :losers_side, :boolean
    end
  end

  def self.down
    drop_table :im_brackets
  end
end
