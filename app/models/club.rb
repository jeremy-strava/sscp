class Club < ActiveRecord::Base
	
	attr_accessible      :name,:strava_club_id,:location
	
	has_many :members
	has_many :leader_boards
end
