class CreateImDayOfPlays < ActiveRecord::Migration
  def self.up
    create_table :im_day_of_plays do |t|
      t.column :im_sport_id, :integer
      t.column :dop_name, :string
      t.column :imtrack_id, :integer
    end
  end

  def self.down
    drop_table :im_day_of_plays
  end
end
