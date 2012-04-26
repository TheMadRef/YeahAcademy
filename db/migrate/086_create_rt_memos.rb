class CreateRtMemos < ActiveRecord::Migration
  def self.up
    create_table :rt_memos do |t|
      t.column :memo_title, :string
      t.column :summary, :text
      t.column :active, :boolean, :default => true
      t.column :created_on, :date
      t.column :memo_file, :string
    end
  end

  def self.down
    drop_table :rt_memos
  end
end
