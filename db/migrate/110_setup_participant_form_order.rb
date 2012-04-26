class SetupParticipantFormOrder < ActiveRecord::Migration
  def self.up
		ParticipantCustomField.delete_all
  	ParticipantFormOrder.create(:participant_column_human_name => "First Name", :participant_column_name => "first_name", :participant_column_required => true, :sort_number => 1)
  	ParticipantFormOrder.create(:participant_column_human_name => "Middle Initial", :participant_column_name => "mi", :participant_column_required => true, :sort_number => 2)
  	ParticipantFormOrder.create(:participant_column_human_name => "Last Name", :participant_column_name => "last_name", :participant_column_required => true, :sort_number => 3)
  	ParticipantFormOrder.create(:participant_column_human_name => "Email Address", :participant_column_name => "email", :participant_column_required => true, :sort_number => 4)
  	ParticipantFormOrder.create(:participant_column_human_name => "Address Line 1", :participant_column_name => "address_line_1", :participant_column_required => true, :sort_number => 5)
  	ParticipantFormOrder.create(:participant_column_human_name => "Address Line 2", :participant_column_name => "address_line_2", :participant_column_required => false, :sort_number => 6)
  	ParticipantFormOrder.create(:participant_column_human_name => "City", :participant_column_name => "city", :participant_column_required => true, :sort_number => 7)
  	ParticipantFormOrder.create(:participant_column_human_name => "State", :participant_column_name => "state", :participant_column_required => true, :sort_number => 8)
  	ParticipantFormOrder.create(:participant_column_human_name => "Zip Code", :participant_column_name => "zip", :participant_column_required => true, :sort_number => 9)
  	ParticipantFormOrder.create(:participant_column_human_name => "Phone Number", :participant_column_name => "phone", :participant_column_required => true, :sort_number => 10)
  	ParticipantFormOrder.create(:participant_column_human_name => "Category", :participant_column_name => "category_id", :participant_column_required => false, :sort_number => 11, :participant_column_type => "category")
  	ParticipantFormOrder.create(:participant_column_human_name => "Date of Birth", :participant_column_name => "date_of_birth", :participant_column_required => false, :sort_number => 12, :participant_column_type => "date_select")
  	ParticipantFormOrder.create(:participant_column_human_name => "Gender", :participant_column_name => "gender", :participant_column_required => false, :sort_number => 13, :participant_column_type => "gender")
  end

  def self.down
		ParticipantFormOrder.delete_all
  end
end