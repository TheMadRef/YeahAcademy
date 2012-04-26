class AddColumnsToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :participant_id, :integer
    add_column :orders, :completed, :boolean, :default => false
  end

  def self.down
    remove_column :orders, :participant_id
    remove_column :orders, :completed
  end
end
