class CreateImColumnHeaders < ActiveRecord::Migration
  def self.up
    create_table :im_column_headers do |t|
    	t.column :im_sport_id, :integer
    	t.column :header_name, :string
    	t.column :index, :integer
    end
  end

  def self.down
    drop_table :im_column_headers
  end
end
