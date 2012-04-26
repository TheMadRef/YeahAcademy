class EditLeagueColumnMaxAllowed < ActiveRecord::Migration
  def self.up
    change_column :im_leagues, :max_allowed, :integer, {:default => 0}
    change_column :im_leagues, :parent_id, :integer, {:default => 0}
  end

  def self.down
  end
end
