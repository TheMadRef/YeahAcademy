class CreateImRankingBreakdowns < ActiveRecord::Migration
  def self.up
    create_table :im_ranking_breakdowns do |t|
    	t.column :im_ranking_id, :integer
    	t.column :equals, :boolean
    	t.column :miniimum, :string
    	t.column :maximum, :string
    	t.column :bonus, :integer
    end
  end

  def self.down
    drop_table :im_ranking_breakdowns
  end
end
