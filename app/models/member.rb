class Member < ActiveRecord::Base
	
	attr_accessible   :name,:club_id, :strava_member_id
	
	has_many :rides
	has_one :club
end
