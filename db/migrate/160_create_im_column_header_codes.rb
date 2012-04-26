class CreateImColumnHeaderCodes < ActiveRecord::Migration
  def self.up
    create_table :im_column_header_codes do |t|
    	t.column :header_name, :string
    	t.column :display_name, :string
    	t.column :column_name, :string
    	t.column :alignment, :string
    end
  end

  def self.down
    drop_table :im_column_header_codes
  end
end
