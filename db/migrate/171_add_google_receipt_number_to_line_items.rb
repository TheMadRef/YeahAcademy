class AddGoogleReceiptNumberToLineItems < ActiveRecord::Migration
  def self.up
  	add_column :line_items, :google_receipt_number, :string
  end

  def self.down
  	remove_column :line_items, :google_receipt_number
  end
end
