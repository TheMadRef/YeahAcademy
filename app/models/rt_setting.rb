class RtSetting < ActiveRecord::Base

  validates_presence_of :system_name
  validates_presence_of :master_rt_terms_and_conditions_text, :if => :master_rt_terms_and_conditions
end
