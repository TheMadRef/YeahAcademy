class AddIndividualSportColumn < ActiveRecord::Migration
  def self.up
    add_column :im_sports, :individual_sport, :boolean, :default => false
  end

  def self.down
    remove_column :im_sports, :individual_sport
  end
end
