class AddViewableColumnToRtUserGroup < ActiveRecord::Migration
  def self.up
  	add_column :rt_user_groups, :internal, :boolean, :default => false
  end

  def self.down
  	remove_column :rt_user_groups, :internal
  end
end
