class AddAutoClearOverduePaymentTransactionsToMasterSettings < ActiveRecord::Migration
  def self.up
  	add_column :master_settings, :auto_delete_past_due_items, :boolean, :default => false
  end

  def self.down
  	remove_column :master_settings, :auto_delete_past_due_items
  end
end
