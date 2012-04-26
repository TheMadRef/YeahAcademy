class CreateImWebSettingSecurities < ActiveRecord::Migration
  def self.up
    create_table :im_web_setting_securities do |t|
    	t.column :ftp_option, :integer
    	t.column :host_name, :string
    	t.column :ssl, :boolean
    	t.column :login_name, :string
    	t.column :login_password, :string
    	t.column :upload_directory, :string
    	t.column :page_directory, :string
    	t.column :external_program, :string
    	t.column :command_line_argument, :string
    end
  end

  def self.down
    drop_table :im_web_setting_securities
  end
end
