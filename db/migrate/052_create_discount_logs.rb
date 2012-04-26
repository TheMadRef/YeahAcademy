class CreateDiscountLogs < ActiveRecord::Migration
  def self.up
    create_table :discount_logs do |t|
      t.column :participant_id, :integer
      t.column :comment, :string
      t.column :amount, :decimal, :precision => 8, :scale => 2, :default => 0
    end
    add_column :line_items, :discount_log_id, :integer
    add_column :line_items, :created_at, :timestamp
  end

  def self.down
    drop_table :discount_logs
    remove_column :line_items, :discount_log_id
    remove_column :line_items, :created_at
  end
end
