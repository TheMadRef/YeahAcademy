class CreateImGameOfTheDays < ActiveRecord::Migration
  def self.up
    create_table :im_game_of_the_days do |t|
    	t.column :im_sport_id, :integer
    	t.column :game_date, :datetime
    	t.column :im_game_id, :integer
    	t.column :previous_im_game_id, :integer
    	t.column :global, :boolean
    	t.column :header, :string
    	t.column :coments, :text
    	t.column :show_previous, :boolean
    end
  end

  def self.down
    drop_table :im_game_of_the_days
  end
end
