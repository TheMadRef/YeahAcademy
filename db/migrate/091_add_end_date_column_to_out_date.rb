class AddEndDateColumnToOutDate < ActiveRecord::Migration
  def self.up
    add_column :rt_participant_out_dates, :end_date, :date
  end

  def self.down
    remove_column :rt_participant_out_dates, :end_date
  end
end
