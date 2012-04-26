class CreateRtMemoUserGroupRelationships < ActiveRecord::Migration
  def self.up
    create_table :rt_memo_user_group_relationships do |t|
      t.column :rt_user_group_id, :integer
      t.column :rt_memo_id, :integer
    end
  end

  def self.down
    drop_table :rt_memo_user_group_relationships
  end
end
