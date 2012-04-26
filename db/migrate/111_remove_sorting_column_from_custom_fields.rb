class RemoveSortingColumnFromCustomFields < ActiveRecord::Migration
  def self.up
		remove_column :participant_custom_fields, :sorting_number
  end

  def self.down
		add_column :participant_custom_fields, :sorting_number, :integer
  end
end
