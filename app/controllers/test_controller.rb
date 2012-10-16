class TestController < ActionController::Base
  def team_members
  		#response = HTTParty.get('http://www.strava.com/api/v1/clubs/' + params[:id].to_s + '/members')
  			response = HTTParty.get('http://www.strava.com/api/v1/clubs/' + params[:id].to_s )
  		
  		render :json response
 	end
 	def athlete_rides
 		response = HTTParty.get('http://app.strava.com/api/v1/rides?athleteId=' + params[:id].to_s)
  			
  	render :json => response.body
 	
	end
	def athlete_effort
		
			response = HTTParty.get('http://www.strava.com/api/v1/rides/' + params[:id].to_s)
  		#	startDate=2010-02-28
  	render :json => response.body
		
end
end
