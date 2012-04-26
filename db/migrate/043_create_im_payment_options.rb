class CreateImPaymentOptions < ActiveRecord::Migration
  def self.up
    create_table :im_payment_options do |t|
      t.column :payment_option, :string
      t.column :team_payment_selection, :string
    end
  end

  def self.down
    drop_table :im_payment_options
  end
end
