class CreateRtParticipantOutDates < ActiveRecord::Migration
  def self.up
    create_table :rt_participant_out_dates do |t|
      t.column :participant_id, :integer
      t.column :parent_id, :integer, :default => 0
      t.column :out_date, :date, :default => Time.now
      t.column :start_time, :time, :default => "00:00:00"
      t.column :end_time, :time, :default => "23:55:00"
      t.column :comment, :text
    end
  end

  def self.down
    drop_table :rt_participant_out_dates
  end
end
