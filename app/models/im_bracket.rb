class ImBracket < ActiveRecord::Base
	belongs_to :im_sport
	belongs_to :im_league
	has_many :im_games, :dependent => :destroy
end
