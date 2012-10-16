class Ride < ActiveRecord::Base
	
	attr_accessible    :strava_ride_id,:elevation_gain,:start_date,:member_id
	
	belongs_to :member
	
end
