class AddImColumnHeaderCodeId < ActiveRecord::Migration
  def self.up
  	add_column :im_column_headers, :im_column_header_code_id, :integer
  end

  def self.down
  	remove_column :im_column_headers, :im_column_header_code_id
  end
end
