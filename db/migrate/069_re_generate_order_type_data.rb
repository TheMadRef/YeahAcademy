class ReGenerateOrderTypeData < ActiveRecord::Migration
  def self.up
	PaymentType.delete_all
  end

  def self.down
	PaymentType.delete_all
  end
end
