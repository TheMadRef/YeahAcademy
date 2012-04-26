class CreateFtReservations < ActiveRecord::Migration
  def self.up
    create_table :ft_reservations do |t|
    end
  end

  def self.down
    drop_table :ft_reservations
  end
end
