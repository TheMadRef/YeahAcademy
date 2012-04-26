class AddMasterSettingData < ActiveRecord::Migration
	def self.up
		MasterSetting.delete_all
	end

	def self.down
		MasterSetting.delete_all
	end
end
