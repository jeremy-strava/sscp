
module LeaderboardBuilder


	 def LeaderboardBuilder.build_leader_board(year,month,club_id )
    #builds the leader board for a given month and year for a given club
    #the results are cached inthe database so we dont have to go to the api for every request
   	api_root = Sscp::Application::STRAVA_API_ROOT
   
    club_from_db = Club.find_by_strava_club_id(club_id)
   
   	if not club_from_db
   		@strava_club = HTTParty.get(api_root +'clubs/' + club_id ).parsed_response["club"]

   		
   			club_from_db = Club.new({:name => @strava_club['name'] , 
   														 :strava_club_id => @strava_club['id'], 
   														 :location => @strava_club['location'] })	
   			club_from_db.save
    end
   
   db_leader_board = Leaderboard.find_by_month_and_year_and_club_id(month.to_s,year.to_s,club_from_db.id)
   if not db_leader_board
   		db_leader_board = Leaderboard.new({:club_id => club_from_db.id,:month => month, :year => year})
 	 end
   db_leader_board.is_building = true
   puts db_leader_board.save.to_s + "ZZZZZZZZZZZZZZZZZZZZZ"
  
   

   @members = HTTParty.get(api_root + 'clubs/' + club_id + '/members').parsed_response["members"]
   
   @members.each do |member|
   		db_member = Member.find_by_strava_member_id(member["id"]) 
   		if not db_member
   				db_member = Member.new({:name => member["name"], :club_id => club_from_db.id, :strava_member_id => member["id"] })
   				db_member.save
  		end
  		
  		last_day_of_month = DateTime.new(year.to_i,month.to_i,-1).day
   		@rides = HTTParty.get(api_root + 'rides?startDate=' + year.to_s + '-' + 
   												month.to_s + '-01&endDate=' + year.to_s + '-' + 
   												month.to_s + '-' + last_day_of_month.to_s + '&athleteId=' + 
   													member["id"].to_s ).parsed_response["rides"]

   		@rides.each do |ride|
   			ride_details = HTTParty.get( api_root + 'rides/' + ride["id"].to_s ).parsed_response["ride"]
   		  ride_detail = Ride.find_by_strava_ride_id(ride["id"])
   			
   			if not ride_detail
   					new_ride = Ride.new({:member_id => db_member.id,
   																:strava_ride_id => ride_details["id"], 
   																:elevation_gain => ride_details["elevationGain"], 
   																:start_date => ride_details["startDate"]})
   					new_ride.save
  			end
  		end	
  			db_leader_board.is_building = false
  			db_leader_board.save
  	end
  end
end
