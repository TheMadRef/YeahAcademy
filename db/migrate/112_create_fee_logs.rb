class CreateFeeLogs < ActiveRecord::Migration
  def self.up
    create_table :fee_logs do |t|
      t.column :participant_id, :integer
      t.column :comment, :string
      t.column :amount, :decimal, :precision => 8, :scale => 2, :default => 0
    end
    add_column :line_items, :fee_log_id, :integer
    PaymentItem.create(:payment_item => 'Fee/Charge', :table_name => 'fee_logs')
  end

  def self.down
    drop_table :fee_logs
    remove_column :line_items, :fee_log_id
  end
end
