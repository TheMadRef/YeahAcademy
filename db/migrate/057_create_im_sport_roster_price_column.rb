class CreateImSportRosterPriceColumn < ActiveRecord::Migration
  def self.up
    add_column :im_sports, :roster_price, :decimal, :precision => 8, :scale => 2, :default => 0    
    add_column :im_teams, :charge_roster, :boolean, :default => false
  end

  def self.down
    remove_column :im_sports, :roster_price
    remove_column :im_teams, :charge_roster
  end
end
