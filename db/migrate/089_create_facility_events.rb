class CreateFacilityEvents < ActiveRecord::Migration
  def self.up
    create_table :facility_events do |t|
      t.column :im_game_id, :integer
      t.column :ft_reservation_id, :integer
    end
  end

  def self.down
    drop_table :facility_events
  end
end
