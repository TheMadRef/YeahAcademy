class AddImSportWelcomeMessage < ActiveRecord::Migration
  def self.up
  	add_column :im_sports, :welcome_message, :text
  end

  def self.down
  	remove_column :im_sports, :welcome_message
  end
end
