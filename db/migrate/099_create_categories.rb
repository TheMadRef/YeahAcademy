class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
			t.column :category_name, :string
			t.column :parent_id, :integer
    end
  end

  def self.down
    drop_table :categories
  end
end
