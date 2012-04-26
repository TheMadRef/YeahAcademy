class AddYeahColumnToParticipants < ActiveRecord::Migration
  def self.up
    add_column :participants, :yeah_code, :string
  end

  def self.down
    remove_column :participants, :yeah_code
  end
end
