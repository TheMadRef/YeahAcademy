class CreateImRankings < ActiveRecord::Migration
  def self.up
    create_table :im_rankings do |t|
    	t.column :breakdown, :string
    	t.column :offense, :boolean
    	t.column :im_sport_id, :integer
    end
  end

  def self.down
    drop_table :im_rankings
  end
end
