class CreateImDopDates < ActiveRecord::Migration
  def self.up
    create_table :im_dop_dates do |t|
    	t.column :im_day_of_play_id, :integer
    	t.column :date, :datetime
    	t.column :index, :integer
    end
  end

  def self.down
    drop_table :im_dop_dates
  end
end
