class AddCtSettingData < ActiveRecord::Migration
  def self.up
		CtSetting.delete_all
		CtSetting.create(:participant_limit_per_class => 99,
		:participant_overall_limit => 99,
        :system_name => 'CTOnline Registration',
        :verify_ct_eligibility => 1,
		:welcome_message => 'Online Registration System',
        :last_member_export => Date.today,  
        :master_ct_terms_and_conditions => false,
		:master_ct_terms_and_conditions_text => 'The master terms and conditions option makes it mandatory for all participants to accept the conditions listed on this text field  before being able to buy or join a class.  Thus, the admin can only add a participant to a class if the person has already signed the terms and conditions.  Edit this text to specify your master terms and conditions.',
		:class_terms_and_conditions => false,
		:class_terms_and_conditions_text => 'The class terms and conditions option makes it mandatory for participants to accept the conditions listed on this text field before being able to buy or join a class.  Therefore, the admin can not add participants to classes because each individual participant must sign the terms and conditions. Edit this text to specify your default class terms and conditions.')
	end

	def self.down
		ImSetting.delete_all
	end
end
