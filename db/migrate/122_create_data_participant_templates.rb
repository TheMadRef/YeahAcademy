class CreateDataParticipantTemplates < ActiveRecord::Migration
  def self.up
    create_table :data_participant_templates do |t|
    	t.column :data_template_id, :integer
    	t.column :record_length, :integer
    	t.column :member_id, :string
    	t.column :card_number, :string
    	t.column :last_name, :string
    	t.column :mi, :string
    	t.column :first_name, :string
    	t.column :title, :string
    	t.column :gender, :string
    	t.column :date_of_birth, :string
    	t.column :address_line_1, :string
    	t.column :address_line_2, :string
    	t.column :city, :string
    	t.column :state, :string
    	t.column :zip, :string
    	t.column :home_phone, :string
    	t.column :work_phone, :string
    	t.column :mobile_phone, :string
    	t.column :fax, :string
    	t.column :email_address, :string
    	t.column :emergency_name, :string
    	t.column :emergency_phone, :string
    	t.column :job_title, :string
    	t.column :mail_code, :string
    	t.column :category, :string
    	t.column :sub_category, :string
    	t.column :start_date, :string
    	t.column :end_date, :string
    	t.column :comments, :string
    	t.column :imtrack, :string
    	t.column :classtrack, :string
    end
  end

  def self.down
    drop_table :data_participant_templates
  end
end
