class LeaderboardsController < ApplicationController
  # GET /leaderboards
  # GET /leaderboards.json
  def index
   club_id = params[:id]
   month = params[:month].to_i
   year = params[:year].to_i
   
   @club = Club.find_by_strava_club_id(club_id)
   if not @club
   
   @leader_board = Leaderboard.find_by_month_and_year_and_club_id(month,year,@club.id)
    if not @leader_board
   		build_leader_board(year,month,club_id)
  	else	   
		
		 start_date = DateTime.new(year,month,1).strftime("%Y-%m-%d")
		 end_date = DateTime.new(year,month,DateTime.new(year,month,-1).day ).strftime("%Y-%m-%d")
		 
		 @rides = Ride.select("member_id, sum(elevation_gain) as total_elevation")
		 @rides = @rides.group("member_id")
		 @rides = @rides.includes(:member).having("start_date >= '" + start_date + "' and start_date <= '" + end_date + "'" ).order("total_elevation DESC")
  	end
 	end
  def build_leader_board(year,month,club_id )
    
   api_root ="http://www.strava.com/api/v1/"
   
   
   club_from_db = Club.find_by_strava_club_id(club_id)
   
   if not db_club
   	@strava_club = HTTParty.get(api_root +'clubs/' + club_id ).parsed_response["club"]
   	club_from_db = Club.new({:name => @strava_club['name'] , :strava_club_id => @strava_club['id'], :location => @strava_club['location'] })	
   	club_from_db.save
   end
   
   db_leader_board = Leaderboard.find_by_month_and_year_and_club_id(month.to_s,year.to_s,db_club.id)
   if not db_leader_board
   		db_leader_board = Leaderboard.new({:is_bulding => true,:club_id => club_from_db.id,:month => month, :year => year})
   		db_leader_board.save
  else
   		db_leader_board.is_building = true
   		db_leader_board.save
   end
   

   @members = HTTParty.get(api_root + 'clubs/' + club_id + '/members').parsed_response["members"]
   
   @members.each do |member|
   		db_member = Member.find_by_strava_member_id(member["id"]) 
   		if not db_member
   				db_member = Member.new({:name => member["name"], :club_id => club_from_db.id, :strava_member_id => member["id"] })
   				db_member.save
  		end
  		puts member["id"]
  		last_day_of_month = DateTime.new(year.to_i,month.to_i,-1).day
   		@rides = HTTParty.get(api_root + 'rides?startDate=' + year.to_s + '-' + month.to_s + '-01&endDate=' + year.to_s + '-' + month.to_s + '-' + last_day_of_month.to_s + '&athleteId=' + member["id"].to_s ).parsed_response["rides"]

   		@rides.each do |ride|
   			ride_details = HTTParty.get( api_root + 'rides/' + ride["id"].to_s ).parsed_response["ride"]
   		  ride_detail = Ride.find_by_strava_ride_id(ride["id"])
   			puts ride_detail
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
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @leaderboards }
    end
  end


  
 
end
