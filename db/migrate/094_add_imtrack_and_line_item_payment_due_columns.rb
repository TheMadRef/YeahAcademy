class AddImtrackAndLineItemPaymentDueColumns < ActiveRecord::Migration
  def self.up
    add_column :terms, :default_team_payment_due_date, :datetime
    add_column :im_sports, :payment_due_date, :datetime, :default => Time.now
    add_column :line_items, :payment_due_date, :datetime, :default => Time.now + 99999999
  end

  def self.down
  	remove_column :terms, :default_team_payment_due_date
  	remove_column :im_sports, :payment_due_date
  	remove_column :line_items, :payment_due_date
  end
end
