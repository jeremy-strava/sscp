class CreateRidesTable < ActiveRecord::Migration
  def up
  	 create_table :rides do |t|
      t.integer :strava_ride_id
      t.float :elevation_gain
      t.datetime :start_date
			t.integer :member_id
      t.timestamps
      
     end
  end

  def down
  	drop_table :rides
  end
end
