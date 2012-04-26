class CreateImOptions < ActiveRecord::Migration
  def self.up
    create_table :im_options do |t|
    	t.column :option, :string
    	t.column :flag, :string
    end
  end

  def self.down
    drop_table :im_options
  end
end
