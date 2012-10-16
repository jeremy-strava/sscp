class CreateMembersTable < ActiveRecord::Migration
  def up
  	 create_table :members do |t|
      t.string :name
      t.integer :club_id
      t.integer :strava_member_id
      t.timestamps
      
     end
  end

  def down
  	drop_table :members
  end
end
