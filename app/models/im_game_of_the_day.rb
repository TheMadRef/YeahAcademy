class ImGameOfTheDay < ActiveRecord::Base
	belongs_to :im_sport
	belongs_to :im_game
end
