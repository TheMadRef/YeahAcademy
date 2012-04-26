class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.column :payment_type_id, :integer
      t.column :created_at, :timestamp
    end
  end

  def self.down
    drop_table :orders
  end
end
