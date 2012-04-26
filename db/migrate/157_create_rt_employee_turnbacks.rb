class CreateRtEmployeeTurnbacks < ActiveRecord::Migration
  def self.up
    create_table :rt_employee_turnbacks do |t|
    	t.column :participant_id, :integer
    	t.column :im_game_id, :integer
    end
  end

  def self.down
    drop_table :rt_employee_turnbacks
  end
end
