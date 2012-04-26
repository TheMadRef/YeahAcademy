class AddEarlyBirdAndDueDateColumnsForClassses < ActiveRecord::Migration
  def self.up
    add_column :terms, :default_class_early_bird_date, :datetime
    add_column :terms, :default_class_early_bird_discount, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :terms, :default_class_payment_due_date, :datetime
    add_column :ct_classes, :default_early_bird_date, :datetime
    add_column :ct_classes, :default_early_bird_discount, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :ct_classes, :default_payment_due_date, :datetime
    add_column :ct_sessions, :s_early_bird_date, :datetime
    add_column :ct_sessions, :s_early_bird_discount, :decimal, :precision => 8, :scale => 2, :default => 0
    add_column :ct_sessions, :s_payment_due_date, :datetime, :default => Time.now
    add_column :master_settings, :default_payment_due_setting, :boolean, :default => false
    add_column :master_settings, :default_payment_due_days, :integer, :default => 2
  end

  def self.down
    remove_column :terms, :default_class_early_bird_date
    remove_column :terms, :default_class_early_bird_discount
    remove_column :terms, :default_class_payment_due_date
    remove_column :ct_classes, :default_early_bird_date
    remove_column :ct_classes, :default_early_bird_discount
    remove_column :ct_classes, :default_payment_due_date
    remove_column :ct_sessions, :s_early_bird_date
    remove_column :ct_sessions, :s_early_bird_discount
    remove_column :ct_sessions, :s_payment_due_date
    remove_column :master_settings, :default_payment_due_setting
    remove_column :master_settings, :default_payment_due_days
  end
end
