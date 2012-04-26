class CreateImProductInformations < ActiveRecord::Migration
  def self.up
    create_table :im_product_informations do |t|
    	t.column :customer_id, :string
    	t.column :customer_name, :string
    	t.column :master_serial_number, :string
    	t.column :evaluation_start_date, :string
    	t.column :evaluation_stop_date, :string
    end
  end

  def self.down
    drop_table :im_product_informations
  end
end
