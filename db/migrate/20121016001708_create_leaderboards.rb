class CreateLeaderboards < ActiveRecord::Migration
  def change
    create_table :leaderboards do |t|
      t.integer :club_id
			t.integer :month
			t.integer :year
			t.boolean :is_building, :null =>false
      t.timestamps
    end
  end
end
