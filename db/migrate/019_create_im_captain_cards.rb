class CreateImCaptainCards < ActiveRecord::Migration
  def self.up
    create_table :im_captain_cards do |t|
      t.column :password, :text
      t.column :participant_id, :integer
    end
  end

  def self.down
    drop_table :im_captain_cards
  end
end
