class CreateClubTable < ActiveRecord::Migration
  def up
  	 create_table :clubs do |t|
      t.string :name
      t.integer :strava_club_id
      t.string :location
 
      t.timestamps
      
     end
  end

  def down
  	drop_table :clubs
  end
end
