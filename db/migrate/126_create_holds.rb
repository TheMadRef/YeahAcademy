class CreateHolds < ActiveRecord::Migration
  def self.up
    create_table :holds do |t|
    	t.column :active, :boolean
    	t.column :participant_id, :integer
    	t.column :option_1, :string
    	t.column :option_2, :string
    	t.column :option_3, :string
    	t.column :option_4, :string
    	t.column :option_5, :string
    	t.column :option_6, :string
    	t.column :duration, :integer
    	t.column :start_date, :datetime
    	t.column :end_date, :datetime
    	t.column :total_count, :integer
    	t.column :count_left, :integer
    	t.column :description, :text
    	t.column :added_by, :string
    end
  end

  def self.down
    drop_table :holds
  end
end
