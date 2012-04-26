class CreateRtEmployeeSchedules < ActiveRecord::Migration
  def self.up
    create_table :rt_employee_schedules do |t|
      t.column :participant_id, :integer
      t.column :im_game_id, :integer
      t.column :rt_employee_title_id, :integer
    end
  end

  def self.down
    drop_table :rt_employee_schedules
  end
end
