class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.column :participant_id,         :integer, :null => false
      t.column :order_id,               :integer
      t.column :payment_item_id,        :integer, :null => false
      t.column :im_team_id,             :integer
      t.column :im_roster_id,           :integer
      t.column :ct_roster_id,           :integer
      t.column :price,                  :decimal, :null => false, :precision => 8, :scale => 2     
    end
  end

  def self.down
    drop_table :line_items
  end
end
