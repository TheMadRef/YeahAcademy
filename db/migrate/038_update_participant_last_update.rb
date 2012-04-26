class UpdateParticipantLastUpdate < ActiveRecord::Migration
  def self.up
    add_column :participants, :updated_at, :timestamp
    remove_column :participants, :last_update
  end

  def self.down
    remove_column :participants, :updated_at
    add_column :participants, :last_update, :timestamp
  end
end
