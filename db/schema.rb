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

ActiveRecord::Schema.define(version: 20160402122345) do

  create_table "matches", force: :cascade do |t|
    t.integer  "redGoal",    null: false
    t.integer  "blueGoal",   null: false
    t.string   "winner",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_matches", force: :cascade do |t|
    t.integer  "player_id",            null: false
    t.integer  "match_id",             null: false
    t.string   "team",                 null: false
    t.string   "position",   limit: 3, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "players", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "alias",      limit: 5,                null: false
    t.boolean  "active",               default: true, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "wins",       null: false
    t.integer  "loses",      null: false
    t.integer  "points",     null: false
    t.integer  "goals",      null: false
    t.float    "wRatio",     null: false
    t.integer  "pullUps",    null: false
    t.integer  "win_streak", null: false
    t.integer  "player_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
