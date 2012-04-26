class CreateRtEmployeeTitleLeagueRelationships < ActiveRecord::Migration
  def self.up
    create_table :rt_employee_title_league_relationships do |t|
      t.column :rt_employee_title_id, :integer
      t.column :im_league_id, :integer
      t.column :rt_user_group_id, :integer, :default => 0
    end
  end

  def self.down
    drop_table :rt_employee_title_league_relationships
  end
end
