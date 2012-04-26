class EditCtLateFeeColumns < ActiveRecord::Migration
  def self.up
    rename_column :ct_classes, :default_late_price, :default_late_fee
    rename_column :ct_sessions, :s_late_price, :s_late_fee
  end

  def self.down
    rename_column :ct_classes, :default_late_fee, :default_late_price
    rename_column :ct_sessions, :s_late_fee, :s_late_price
  end
end
