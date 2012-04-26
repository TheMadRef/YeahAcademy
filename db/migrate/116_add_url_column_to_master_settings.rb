class AddUrlColumnToMasterSettings < ActiveRecord::Migration
  def self.up
		add_column :master_settings, :return_url, :string, :default => "localhost:3000"
  end

  def self.down
  	remove_column :master_settings, :return_url
  end
end
