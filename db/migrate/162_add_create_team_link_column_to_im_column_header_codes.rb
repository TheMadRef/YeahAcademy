class AddCreateTeamLinkColumnToImColumnHeaderCodes < ActiveRecord::Migration
  def self.up
  	add_column :im_column_header_codes, :link_to_team, :boolean, :default => false
  end

  def self.down
		remove_column :im_column_header_codes, :link_to_team
  end
end
