class AddParentIdColumnToParticipants < ActiveRecord::Migration
  def self.up
  	add_column :participants, :parent_id, :integer, :default => 0
  end

  def self.down
  	remove_column :participants, :parent_id
  end
end
