class CreatePaymentItems < ActiveRecord::Migration
  def self.up
    create_table :payment_items do |t|
      t.column :payment_item, :string
      t.column :table_name, :string
    end
  end

  def self.down
    drop_table :payment_items
  end
end
