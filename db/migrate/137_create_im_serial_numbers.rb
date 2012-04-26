class CreateImSerialNumbers < ActiveRecord::Migration
  def self.up
    create_table :im_serial_numbers do |t|
    	t.column :serial_number, :integer
    	t.column :installed, :boolean
    	t.column :logged_in, :boolean
    	t.column :desktop_user_id, :integer
    end
  end

  def self.down
    drop_table :im_serial_numbers
  end
end
