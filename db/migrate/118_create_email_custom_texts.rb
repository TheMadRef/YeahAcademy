class CreateEmailCustomTexts < ActiveRecord::Migration
  def self.up
    create_table :email_custom_texts do |t|
    	t.column :master_header, :text
    	t.column :master_footer, :text
    	t.column :receipt_header, :text
    	t.column :receipt_footer, :text
    end
  end

  def self.down
    drop_table :email_custom_texts
  end
end
