class AddDefaultCategoryColumn < ActiveRecord::Migration
  def self.up
  	add_column :categories, :default_category, :boolean, :default => false
  end

  def self.down
  	remove_column :categories, :default_category
  end
end
