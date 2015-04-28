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

ActiveRecord::Schema.define(version: 20150428173939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "guild_members", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "ep"
    t.integer  "gp"
    t.integer  "guild_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.float    "pr"
    t.string   "strClass",   limit: 255
    t.string   "strRole"
  end

  add_index "guild_members", ["guild_id"], name: "index_guild_members_on_guild_id", using: :btree

  create_table "guilds", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "owner",      limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "realm",      limit: 255
  end

  create_table "items", force: :cascade do |t|
    t.integer  "ingame_id"
    t.integer  "timestamp"
    t.integer  "guild_member_id"
    t.integer  "gp_cost"
    t.integer  "of_guild_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "of_member_id"
  end

  add_index "items", ["guild_member_id"], name: "index_items_on_guild_member_id", using: :btree

  create_table "logs", force: :cascade do |t|
    t.string   "strModifier",     limit: 255
    t.string   "strComment",      limit: 255
    t.string   "strType",         limit: 255
    t.string   "strTimestamp",    limit: 255
    t.integer  "guild_member_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "logs", ["guild_member_id"], name: "index_logs_on_guild_member_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                       limit: 255, null: false
    t.string   "crypted_password",            limit: 255
    t.string   "salt",                        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "User",                        limit: 255
    t.integer  "guild_id"
    t.string   "activation_state",            limit: 255
    t.string   "activation_token",            limit: 255
    t.datetime "activation_token_expires_at"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
