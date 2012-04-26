class AddPaymentData < ActiveRecord::Migration
  def self.up
	ImPaymentOption.create(:payment_option => 'When there is a Per Roster Price and a Per Team Price, Charge Both Fees', :team_payment_selection => 'Pay Team Fee')
	ImPaymentOption.create(:payment_option => 'When there is a Per Roster Price and a Per Team Price, Captain can Select Which Fee to Pay', :team_payment_selection => 'Pay Per Roster Fee')
    PaymentItem.create(:payment_item => 'Team Roster Entry', :table_name => 'im_rosters')
    PaymentItem.create(:payment_item => 'Team Entry', :table_name => 'im_teams')
    PaymentItem.create(:payment_item => 'Class Purchase', :table_name => 'ct_rosters')
    PaymentType.create(:payment_type => 'Administrator Override')    
    PaymentType.create(:payment_type => 'Online Payment')
  end

  def self.down
  end
end
