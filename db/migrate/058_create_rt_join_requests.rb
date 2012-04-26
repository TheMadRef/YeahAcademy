class CreateRtJoinRequests < ActiveRecord::Migration
  def self.up
    create_table :rt_join_requests do |t|
      t.column :participant_id, :integer
      t.column :comment, :text
      t.column :declined, :boolean, :default => false
      t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :rt_join_requests
  end
end
