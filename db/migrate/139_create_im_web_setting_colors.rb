class CreateImWebSettingColors < ActiveRecord::Migration
  def self.up
    create_table :im_web_setting_colors do |t|
    	t.column :im_sport_id, :integer
    	t.column :master, :boolean
    	t.column :active_link, :string
    	t.column :bracket_background, :string
    	t.column :bracket_font, :string
    	t.column :bracket_main_font, :string
    	t.column :bracket_shadow, :string
    	t.column :hyperlink, :string
    	t.column :standings_background, :string
    	t.column :standings_dark, :string
    	t.column :standings_dark_font, :string
    	t.column :standings_font, :string
    	t.column :standings_light, :string
    	t.column :standings_light_font, :string
    	t.column :visited_link, :string
    end
  end

  def self.down
    drop_table :im_web_setting_colors
  end
end
