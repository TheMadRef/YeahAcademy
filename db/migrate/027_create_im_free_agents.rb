class CreateImFreeAgents < ActiveRecord::Migration
  def self.up
    create_table :im_free_agents do |t|
      t.column :participant_id, :integer
      t.column :im_league_id, :integer
      t.column :im_division_id, :integer
      t.column :comment, :text
    end
  end

  def self.down
    drop_table :im_free_agents
  end
end
