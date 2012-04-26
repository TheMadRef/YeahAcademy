class CreateMasterSettings < ActiveRecord::Migration
  def self.up
    create_table :master_settings do |t|
      t.column :master_terms_and_conditions, :boolean
      t.column :master_terms_and_conditions_text, :text
      t.column :verify_participants, :boolean, :default => false
      t.column :require_phone_number, :boolean, :default => true
      t.column :require_address, :boolean, :default => true
    end
  end

  def self.down
    drop_table :master_settings
  end
end
