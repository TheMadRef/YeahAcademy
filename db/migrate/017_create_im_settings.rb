class CreateImSettings < ActiveRecord::Migration
  def self.up
    create_table :im_settings do |t|
      t.column :system_name, :string
      t.column :welcome_message, :text
      t.column :participant_roster_limit_per_sport, :integer
      t.column :participant_roster_limit_per_league, :integer
      t.column :overall_captain_limit, :integer
      t.column :captain_limit_per_sport, :integer
      t.column :captain_limit_per_league, :integer
      t.column :captain_limit_per_division, :integer
      t.column :verify_im_eligibility, :boolean
      t.column :captain_cards, :boolean
      t.column :free_agents, :boolean
      t.column :allow_multiple_colors, :boolean
      t.column :master_im_terms_and_conditions, :boolean
      t.column :master_im_terms_and_conditions_text, :text
      t.column :team_terms_and_conditions, :boolean
      t.column :team_terms_and_conditions_text, :text
      t.column :roster_terms_and_conditions, :boolean
      t.column :roster_terms_and_conditions_text, :text
      t.column :last_member_export, :datetime
      t.column :default_page, :string
    end
  end

  def self.down
    drop_table :im_settings
  end
end
