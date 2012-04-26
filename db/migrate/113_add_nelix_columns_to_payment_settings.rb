class AddNelixColumnsToPaymentSettings < ActiveRecord::Migration
  def self.up
		add_column :payment_settings, :nelix, :boolean, :default => false
		add_column :payment_settings, :nelix_user_name, :string
		add_column :payment_settings, :cfm_authorization_authorize_net, :boolean, :default => false
		add_column :payment_settings, :cfm_authorization_nelix, :boolean, :default => false
		add_column :payment_settings, :cfm_authorization_paypal, :boolean, :default => false
  end

  def self.down
		remove_column :payment_settings, :nelix
		remove_column :payment_settings, :nelix_user_name
		remove_column :payment_settings, :cfm_authorization_authorize_net
		remove_column :payment_settings, :cfm_authorization_nelix
		remove_column :payment_settings, :cfm_authorization_paypal	
  end
end
