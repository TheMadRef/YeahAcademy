class AddShowColumnToParticipantFormOrders < ActiveRecord::Migration
  def self.up
  	add_column :participant_form_orders, :show_on_reports, :boolean, :default => true
  end

  def self.down
  	remove_column :participant_form_orders, :show_on_reports
  end
end
