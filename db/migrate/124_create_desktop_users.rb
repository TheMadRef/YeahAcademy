class CreateDesktopUsers < ActiveRecord::Migration
  def self.up
    create_table :desktop_users do |t|
    	t.column :user_name, :string
    	t.column :password, :string
    	t.column :last_name, :string
    	t.column :first_name, :string
    	t.column :imtrack, :boolean
    	t.column :facilitytrack, :boolean
    	t.column :classtrack, :boolean
    	t.column :reftrack, :boolean
    end
  end

  def self.down
    drop_table :desktop_users
  end
end
