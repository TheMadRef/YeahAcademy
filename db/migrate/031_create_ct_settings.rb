class CreateCtSettings < ActiveRecord::Migration
  def self.up
    create_table :ct_settings do |t|
      t.column :system_name, :string
      t.column :welcome_message, :text
      t.column :participant_limit_per_class, :integer
      t.column :participant_overall_limit, :integer
      t.column :verify_ct_eligibility, :boolean, :default => false
      t.column :master_ct_terms_and_conditions, :boolean
      t.column :master_ct_terms_and_conditions_text, :text
      t.column :class_terms_and_conditions, :boolean
      t.column :class_terms_and_conditions_text, :text
      t.column :last_member_export, :datetime
    end
  end

  def self.down
    drop_table :ct_settings
  end
end
