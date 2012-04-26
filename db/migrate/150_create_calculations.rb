class CreateCalculations < ActiveRecord::Migration
  def self.up
    create_table :calculations do |t|
    	t.column :string_1, :string
    	t.column :string_2, :string
    	t.column :string_3, :string
    	t.column :string_4, :string
    	t.column :string_5, :string
			t.column :double_1, :decimal, :precision => 8, :scale => 2
			t.column :double_2, :decimal, :precision => 8, :scale => 2
			t.column :double_3, :decimal, :precision => 8, :scale => 2
			t.column :integer_1, :integer
			t.column :integer_2, :integer
			t.column :integer_3, :integer
			t.column :date_time_1, :datetime
			t.column :date_1, :date
			t.column :time_1, :time
    end
  end

  def self.down
    drop_table :calculations
  end
end
