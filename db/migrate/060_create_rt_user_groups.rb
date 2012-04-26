class CreateRtUserGroups < ActiveRecord::Migration
  def self.up
    create_table :rt_user_groups do |t|
      t.column :user_group_name, :string
      t.column :rt_user_group_type_id, :integer
      t.column :non_employee_view_officials, :boolean, :default => false
      t.column :non_employee_schedule_games, :boolean, :default => false
      t.column :power_view_all_sports, :boolean, :default => false
      t.column :allow_request, :boolean
    end
  end

  def self.down
    drop_table :rt_user_groups
  end
end
