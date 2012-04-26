class ReCreatePaymentItemTable < ActiveRecord::Migration
  def self.up
		drop_table :payment_types
    create_table :payment_types do |t|
      t.column :payment_type, :string
			t.column :admin_pay, :boolean
    end
  end

  def self.down
  end
end
