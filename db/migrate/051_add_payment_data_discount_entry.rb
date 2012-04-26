class AddPaymentDataDiscountEntry < ActiveRecord::Migration
  def self.up
    PaymentType.create(:payment_type => 'Cash')    
    PaymentType.create(:payment_type => 'Check')    
    PaymentType.create(:payment_type => 'Credit Card (Manual)')    
    PaymentType.create(:payment_type => 'Campus ID Card (Manual)')    
    PaymentItem.create(:payment_item => 'Discount/Credit', :table_name => 'discount_logs')
  end

  def self.down
  end
end
