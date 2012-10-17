class Leaderboard < ActiveRecord::Base
	
	attr_accessible  :club_id, :month, :year, :is_building
	
	belongs_to :club
end
