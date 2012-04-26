class CreateRtUserGroupSportRelationships < ActiveRecord::Migration
  def self.up
    create_table :rt_user_group_sport_relationships do |t|
      t.column :rt_user_group_id, :integer
      t.column :im_sport_id, :integer
    end
  end

  def self.down
    drop_table :rt_user_group_sport_relationships
  end
end
