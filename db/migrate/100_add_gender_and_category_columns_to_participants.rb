class AddGenderAndCategoryColumnsToParticipants < ActiveRecord::Migration
  def self.up
		add_column :participants, :category_id, :integer
		add_column :participants, :gender, :boolean, :default => 1
  end

  def self.down
  	remove_column :participants, :category_id
  	remove_column :participants, :gender
  end
end
