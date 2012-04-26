class CreateFacilities < ActiveRecord::Migration
  def self.up
    create_table :facilities do |t|
      t.column :facility_name, :string
      t.column :supervisor_name, :string
      t.column :supervisor_phone, :string
      t.column :supervisor_email, :string
      t.column :address_1, :string
      t.column :address_2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
    end
  end

  def self.down
    drop_table :facilities
  end
end
