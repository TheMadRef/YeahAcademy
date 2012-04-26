class CreateImStatistics < ActiveRecord::Migration
  def self.up
    create_table :im_statistics do |t|
    	t.column :im_sport_id, :integer
    	t.column :stat_name, :string
    	t.column :formula, :string
    	t.column :column_name, :string
    	t.column :print, :boolean
    	t.column :sort, :string
    	t.column :other, :string
    end
  end

  def self.down
    drop_table :im_statistics
  end
end
