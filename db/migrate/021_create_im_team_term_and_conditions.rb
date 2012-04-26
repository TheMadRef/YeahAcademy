class CreateImTeamTermAndConditions < ActiveRecord::Migration
  def self.up
    create_table :im_team_term_and_conditions do |t|
      t.column :im_sport_id, :integer
      t.column :terms_and_conditions, :text
    end
  end

  def self.down
    drop_table :im_team_term_and_conditions
  end
end
