class CreateRtUserGroupTypes < ActiveRecord::Migration
  def self.up
    create_table :rt_user_group_types do |t|
      t.column :user_group_type, :string
      t.column :description, :string
    end
    RtUserGroupType.create(:user_group_type => "Employee", :description => "Officials/Supervisors")
    RtUserGroupType.create(:user_group_type => "Non-Employee", :description => "Coaches/Captains/Administrators")
    RtUserGroupType.create(:user_group_type => "Power User/Evaluators", :description => "Can View all schedules/reports")
  end

  def self.down
    drop_table :rt_user_group_types
  end
end
