class LeaderboardsController < ApplicationController
	
	include LeaderboardBuilder

  def index
  	
   club_id = params[:id]
   month = params[:month].to_i
   year = params[:year].to_i
   refresh = params[:refresh]
   @ranking = 0
   
   @refresh_url = "http://" + request.host + ":" + request.port.to_s + "/leaderboards/" + params[:id] + "?month=" + params[:month] + "&year=" + params[:year] + "&refresh=true"
   
   #see if we already have this club
   club_from_db = Club.find_by_strava_club_id(club_id)

   if not club_from_db
    	#if we dont have the club we cant have the leaderboard
   		LeaderboardBuilder.build_leader_board(year,month,club_id)
   		club_from_db = Club.find_by_strava_club_id(club_id)
   		@leader_board = Leaderboard.find_by_month_and_year_and_club_id(month,year,club_from_db.id)
 	 else
   		@leader_board = Leaderboard.find_by_month_and_year_and_club_id(month,year,club_from_db.id)
    	if not @leader_board or refresh
   			LeaderboardBuilder.build_leader_board(year,month,club_id)
   			@leader_board = Leaderboard.find_by_month_and_year_and_club_id(month,year,club_from_db.id)
 			end	
	 end  
  		
   		
   if not @leader_board.is_building
				 		start_date = DateTime.new(year,month,1).strftime("%Y-%m-%d")
				 		end_date = DateTime.new(year,month,DateTime.new(year,month,-1).day ).strftime("%Y-%m-%d")
				 
				 	 @rides = Ride.all(:joins => :member,
				 	 									:select => "members.name,count(elevation_gain) as number_rides,  sum(elevation_gain) as total_elevation", 
				 	 									:group => "members.name" ,
				 	 									:conditions => ["start_date >='" + start_date +
				 	 													 "' AND start_date <= '" + end_date +
				 	 													  "' AND members.club_id =" + club_from_db.id.to_s],
				 	 									:order =>"total_elevation DESC")
 		else
			 			render :text => "Building leader board please try again later"
		end

	rescue => e
 		render "shared/error"
	
 	end
end
