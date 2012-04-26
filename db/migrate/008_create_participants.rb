class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.column :member_id, :string
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :mi, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :address_line_1, :string
      t.column :address_line_2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :im_active, :boolean
      t.column :imtrack_id, :integer
      t.column :last_update, :datetime
    end
  end

  def self.down
    drop_table :participants
  end
end
