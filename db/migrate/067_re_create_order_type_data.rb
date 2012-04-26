class ReCreateOrderTypeData < ActiveRecord::Migration
  def self.up
    add_column :payment_types, :admin_pay, :boolean, :default => false
  end

  def self.down
    remove_column :payment_types, :admin_pay
		PaymentType.delete_all
  end
end
