class CreateDataTemplates < ActiveRecord::Migration
  def self.up
    create_table :data_templates do |t|
    	t.column :data_template_name, :string
    	t.column :data_template_type, :string
    	t.column :last_run, :datetime
    	t.column :export, :boolean
    	t.column :category_check, :boolean
    	t.column :category_id, :integer
    	t.column :created_by, :string
    end
  end

  def self.down
    drop_table :data_templates
  end
end
