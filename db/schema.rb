# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131110021916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_events", force: true do |t|
    t.integer  "timestamp"
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "event_type"
    t.integer  "event_subtype"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "other_player_id"
    t.string   "position"
  end

  add_index "game_events", ["event_type", "event_subtype"], name: "index_game_events_on_event_type_and_event_subtype", using: :btree
  add_index "game_events", ["event_type"], name: "index_game_events_on_event_type", using: :btree
  add_index "game_events", ["game_id", "player_id"], name: "index_game_events_on_game_id_and_player_id", using: :btree
  add_index "game_events", ["game_id"], name: "index_game_events_on_game_id", using: :btree
  add_index "game_events", ["player_id"], name: "index_game_events_on_player_id", using: :btree

  create_table "games", force: true do |t|
    t.integer  "home_team_id"
    t.integer  "away_team_id"
    t.integer  "home_final_score"
    t.integer  "away_final_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["away_team_id"], name: "index_games_on_away_team_id", using: :btree
  add_index "games", ["home_team_id", "away_team_id"], name: "index_games_on_home_team_id_and_away_team_id", using: :btree
  add_index "games", ["home_team_id"], name: "index_games_on_home_team_id", using: :btree

  create_table "players", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "number"
    t.string   "email"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "league"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["name"], name: "index_teams_on_name", using: :btree

end
