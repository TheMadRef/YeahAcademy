class CreateCtSessionCategoryRestrictions < ActiveRecord::Migration
  def self.up
    create_table :ct_session_category_restrictions do |t|
    	t.column :category_id, :integer
    	t.column :ct_session_id, :integer 
    end
  end

  def self.down
    drop_table :ct_session_category_restrictions
  end
end
