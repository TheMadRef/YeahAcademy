class CreatePaymentColumns < ActiveRecord::Migration
  def self.up
    add_column :im_rosters, :paid, :boolean, :default => true
    add_column :ct_rosters, :paid, :boolean, :default => true
    add_column :im_teams, :paid, :boolean, :default => true
    add_column :im_settings, :im_payment_option_id, :integer, :default => 1
    add_column :ct_settings, :require_approval, :boolean, :default => false
    add_column :im_settings, :require_approval, :boolean, :default => false
  end

  def self.down
    remove_column :im_rosters, :paid
    remove_column :ct_rosters, :paid
    remove_column :im_teams, :paid
    remove_column :im_settings, :im_payment_option_id
    remove_column :ct_settings, :require_approval    
    remove_column :im_settings, :require_approval
  end
end
