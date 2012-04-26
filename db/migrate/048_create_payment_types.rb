class CreatePaymentTypes < ActiveRecord::Migration
  def self.up
    create_table :payment_types do |t|
      t.column :payment_type, :string
    end
  end

  def self.down
    drop_table :payment_types
  end
end
