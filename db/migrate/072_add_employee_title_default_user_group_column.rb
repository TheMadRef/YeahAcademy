class AddEmployeeTitleDefaultUserGroupColumn < ActiveRecord::Migration
  def self.up
    add_column :rt_employee_titles, :rt_user_group_id, :integer
  end

  def self.down
    remove_column :rt_employee_titles, :rt_user_group_id
  end
end
