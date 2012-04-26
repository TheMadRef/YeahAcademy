class ReCreateInitialPaymentSettingsData < ActiveRecord::Migration
  def self.up
 	 PaymentSetting.create(:paypal => false,
                          :paypal_api_user_name => "sales_api1.cfmenterprises.com",
                          :paypal_api_password => "9CTUE3DYEQHWGNKY",
                          :paypal_api_signature => "A8AS1rcHSeYmd7L8rSo4bx.JghPVAIKecNDtBaZSJCBmlNUB0sa84x0a",
                          :cfm_authorization => false,
                          :authorize_net => false,
                          :authorize_net_login => "ftPup862GM9",
                          :authorize_net_transaction_key => "9r232pL6SA2BtjgJ",
                          :receive_payment_notifications => false,
                          :payment_notification_email => "sales@recsolutions.com",
                          :nelix_user_name => "1234"
                          )
  end

  def self.down
  end
end
