class CreateCtRosters < ActiveRecord::Migration
  def self.up
    create_table :ct_rosters do |t|
      t.column :participant_id, :integer
      t.column :ct_session_id, :integer
      t.column :approved, :boolean
    end
  end

  def self.down
    drop_table :ct_rosters
  end
end
