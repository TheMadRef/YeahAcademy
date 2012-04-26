class CreateImColors < ActiveRecord::Migration
  def self.up
    create_table :im_colors do |t|
      t.column :color_name, :string
      t.column :hex, :string
    end
  end

  def self.down
    drop_table :im_colors
  end
end
