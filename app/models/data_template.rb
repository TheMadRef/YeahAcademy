class DataTemplate < ActiveRecord::Base
	has_many :data_participant_templates, :dependent => :destroy
end
