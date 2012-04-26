class CreatePaymentSettings < ActiveRecord::Migration
  def self.up
    create_table :payment_settings do |t|
      t.column :paypal, :boolean
      t.column :paypal_api_user_name, :string
      t.column :paypal_api_password, :string
      t.column :paypal_api_signature, :string
      t.column :cfm_authorization, :boolean, :default => false
      t.column :authorize_net, :boolean
      t.column :authorize_net_login, :string
      t.column :authorize_net_transaction_key, :string
      t.column :receive_payment_notifications, :boolean
      t.column :payment_notification_email, :string
    end
  end

  def self.down
    drop_table :payment_settings
  end
end
