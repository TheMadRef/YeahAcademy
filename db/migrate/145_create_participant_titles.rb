class CreateParticipantTitles < ActiveRecord::Migration
  def self.up
    create_table :participant_titles do |t|
    	t.column :title, :string
    end
  end

  def self.down
    drop_table :participant_titles
  end
end
