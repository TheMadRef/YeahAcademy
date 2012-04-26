class ImRanking < ActiveRecord::Base
	has_many :im_ranking_breakdowns, :dependent => :destroy
	belongs_to :im_sport
end
