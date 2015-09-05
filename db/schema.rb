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

ActiveRecord::Schema.define(version: 20150905154614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alts", force: :cascade do |t|
    t.string   "name"
    t.integer  "guild_member_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "alts", ["guild_member_id"], name: "index_alts_on_guild_member_id", using: :btree

  create_table "api_keys", force: :cascade do |t|
    t.string   "key"
    t.integer  "guild_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cooldown"
    t.integer  "triggered"
  end

  add_index "api_keys", ["guild_id"], name: "index_api_keys_on_guild_id", using: :btree

  create_table "attendances", force: :cascade do |t|
    t.integer  "nSecs"
    t.integer  "raid_type"
    t.integer  "guild_member_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "n_time"
  end

  add_index "attendances", ["guild_member_id"], name: "index_attendances_on_guild_member_id", using: :btree

  create_table "data_sets", force: :cascade do |t|
    t.string   "str_group"
    t.float    "ep"
    t.float    "gp"
    t.float    "pr"
    t.float    "net"
    t.float    "tot"
    t.integer  "guild_member_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "gear_pieces", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "item_type"
    t.integer  "guild_member_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "alt_id"
  end

  add_index "gear_pieces", ["alt_id"], name: "index_gear_pieces_on_alt_id", using: :btree
  add_index "gear_pieces", ["guild_member_id"], name: "index_gear_pieces_on_guild_member_id", using: :btree

  create_table "gear_runes", force: :cascade do |t|
    t.integer  "rune_id"
    t.integer  "gear_piece_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "gear_runes", ["gear_piece_id"], name: "index_gear_runes_on_gear_piece_id", using: :btree

  create_table "guild_members", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "ep"
    t.integer  "gp"
    t.integer  "guild_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.float    "pr"
    t.string   "str_class",  limit: 255
    t.string   "str_role"
    t.integer  "net"
    t.integer  "tot"
    t.integer  "edit_flag"
    t.integer  "p_ga"
    t.integer  "p_ds"
    t.integer  "p_y"
    t.integer  "p_tot"
    t.integer  "pin"
  end

  add_index "guild_members", ["guild_id"], name: "index_guild_members_on_guild_id", using: :btree

  create_table "guilds", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "owner",            limit: 255
    t.string   "email",            limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "realm",            limit: 255
    t.string   "mode",                         default: "EPGP"
    t.integer  "max_events",                   default: 10
    t.integer  "min_affected",                 default: 2
    t.string   "ass_app",                      default: ""
    t.integer  "members_per_page",             default: 20
    t.integer  "items_per_page",               default: 20
    t.integer  "pr_precision",                 default: 2
    t.string   "auto_raid_name",               default: "Auto"
    t.string   "import_status"
  end

  create_table "item_data", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "name"
    t.string   "category"
    t.string   "type"
    t.string   "slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_dbs", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "sprite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "quality"
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
    t.string   "str_comment",     limit: 255
    t.string   "strType",         limit: 255
    t.string   "strTimestamp",    limit: 255
    t.integer  "guild_member_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "n_date"
    t.integer  "n_after"
    t.string   "str_group"
  end

  add_index "logs", ["guild_member_id"], name: "index_logs_on_guild_member_id", using: :btree

  create_table "member_stats", force: :cascade do |t|
    t.integer  "mox"
    t.integer  "brut"
    t.integer  "grit"
    t.integer  "tech"
    t.integer  "fin"
    t.integer  "ins"
    t.integer  "guild_member_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "ap"
    t.integer  "sp"
    t.integer  "alt_id"
  end

  add_index "member_stats", ["alt_id"], name: "index_member_stats_on_alt_id", using: :btree
  add_index "member_stats", ["guild_member_id"], name: "index_member_stats_on_guild_member_id", using: :btree

  create_table "raids", force: :cascade do |t|
    t.string   "name"
    t.integer  "n_time"
    t.integer  "n_finish"
    t.integer  "raid_type"
    t.integer  "guild_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "raids", ["guild_id"], name: "index_raids_on_guild_id", using: :btree

  create_table "rune_sets", force: :cascade do |t|
    t.string   "name"
    t.integer  "count"
    t.integer  "guild_member_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "alt_id"
  end

  add_index "rune_sets", ["alt_id"], name: "index_rune_sets_on_alt_id", using: :btree
  add_index "rune_sets", ["guild_member_id"], name: "index_rune_sets_on_guild_member_id", using: :btree

  create_table "spell_dbs", force: :cascade do |t|
    t.integer  "spell_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                           limit: 255, null: false
    t.string   "crypted_password",                limit: 255
    t.string   "salt",                            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "User",                            limit: 255
    t.integer  "guild_id"
    t.string   "activation_state",                limit: 255
    t.string   "activation_token",                limit: 255
    t.datetime "activation_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer  "assistant"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

  add_foreign_key "alts", "guild_members"
  add_foreign_key "api_keys", "guilds"
  add_foreign_key "attendances", "guild_members"
  add_foreign_key "gear_pieces", "alts"
  add_foreign_key "gear_runes", "gear_pieces"
  add_foreign_key "member_stats", "alts"
  add_foreign_key "member_stats", "guild_members"
  add_foreign_key "raids", "guilds"
  add_foreign_key "rune_sets", "alts"
  add_foreign_key "rune_sets", "guild_members"
end
