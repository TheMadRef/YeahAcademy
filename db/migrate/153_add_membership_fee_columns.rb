class AddMembershipFeeColumns < ActiveRecord::Migration
  def self.up
  	add_column :master_settings, :require_membership_fee, :boolean, :default => false
  	add_column :master_settings, :membership_fee, :decimal, :precision => 8, :scale => 2, :default => 0
  	add_column :master_settings, :application_fee, :decimal, :precision => 8, :scale => 2, :default => 0
  	add_column :participants, :paid_membership_fee, :boolean, :default => false
  	add_column :participants, :paid_application_fee, :boolean, :default => false
  end

  def self.down
  	remove_column :master_settings, :require_membership_fee
  	remove_column :master_settings, :membership_fee
  	remove_column :master_settings, :application_fee
  	remove_column :participants, :paid_membership_fee
  	remove_column :participants, :paid_application_fee
  end
end
