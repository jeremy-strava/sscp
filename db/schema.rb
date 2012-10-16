# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121016125219) do

  create_table "clubs", :force => true do |t|
    t.string   "name"
    t.integer  "strava_club_id"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leaderboards", :force => true do |t|
    t.integer  "club_id"
    t.integer  "month"
    t.integer  "year"
    t.boolean  "is_building"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.integer  "club_id"
    t.integer  "strava_member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rides", :force => true do |t|
    t.integer  "strava_ride_id"
    t.float    "elevation_gain"
    t.datetime "start_date"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
