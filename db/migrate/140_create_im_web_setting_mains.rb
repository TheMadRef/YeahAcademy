class CreateImWebSettingMains < ActiveRecord::Migration
  def self.up
    create_table :im_web_setting_mains do |t|
    	t.column :contact_name, :string
    	t.column :email_address, :string
    	t.column :home_page, :string
    	t.column :company_name, :string
    	t.column :sort, :integer
    	t.column :first_logo, :string
    	t.column :second_logo, :string
    	t.column :hyperlink_one, :string
    	t.column :hyperlink_two, :string
    	t.column :banner_background, :string
    	t.column :banner_font, :string
    	t.column :content_background, :string
    	t.column :content_font, :string
    	t.column :content_hyperlink, :string
    	t.column :message, :text
    end
  end

  def self.down
    drop_table :im_web_setting_mains
  end
end
