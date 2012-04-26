class CreateCtClassTermAndConditions < ActiveRecord::Migration
  def self.up
    create_table :ct_class_term_and_conditions do |t|
      t.column :ct_class_id, :integer
      t.column :terms_and_conditions, :text
    end
  end

  def self.down
    drop_table :ct_class_term_and_conditions
  end
end
