class CreateTerms < ActiveRecord::Migration
  def self.up
    create_table :terms do |t|
      t.column :term_name, :string
    end
  end

  def self.down
    drop_table :terms
  end
end
