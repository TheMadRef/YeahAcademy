class CreateRtEmployeeTitles < ActiveRecord::Migration
  def self.up
    create_table :rt_employee_titles do |t|
      t.column :im_sport_id, :integer
      t.column :employee_title, :string
      t.column :abbreviation, :string
      t.column :sorting_order, :integer, :default => 0
      t.column :make_a_default, :boolean, :default => true 
    end
  end

  def self.down
    drop_table :rt_employee_titles
  end
end
