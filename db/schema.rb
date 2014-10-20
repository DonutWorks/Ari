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

ActiveRecord::Schema.define(version: 20141020140636) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "club_id"
  end

  add_index "admins", ["club_id"], name: "index_admins_on_club_id"
  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "clubs", force: true do |t|
    t.string   "name",       null: false
    t.string   "logo_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "expired",    default: false
    t.integer  "user_id"
    t.integer  "club_id"
  end

  add_index "invitations", ["club_id"], name: "index_invitations_on_club_id"

  create_table "message_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_histories", ["message_id"], name: "index_message_histories_on_message_id"
  add_index "message_histories", ["user_id"], name: "index_message_histories_on_user_id"

  create_table "messages", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "notice_id"
    t.integer  "club_id"
  end

  add_index "messages", ["club_id"], name: "index_messages_on_club_id"

  create_table "notices", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortenURL"
    t.string   "notice_type"
    t.integer  "to"
    t.datetime "due_date"
    t.integer  "club_id"
  end

  add_index "notices", ["club_id"], name: "index_notices_on_club_id"

  create_table "read_activity_marks", force: true do |t|
    t.integer  "reader_id",                 null: false
    t.integer  "readable_id"
    t.string   "readable_type"
    t.integer  "mark",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "responses", force: true do |t|
    t.integer  "user_id"
    t.integer  "notice_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "club_id"
  end

  add_index "responses", ["club_id"], name: "index_responses_on_club_id"

  create_table "users", force: true do |t|
    t.string   "email",                                  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",                               null: false
    t.string   "phone_number"
    t.string   "major"
    t.string   "student_id"
    t.string   "sex"
    t.string   "home_phone_number"
    t.string   "emergency_phone_number"
    t.string   "habitat_id"
    t.string   "member_type"
    t.float    "generation_id"
    t.string   "birth"
    t.boolean  "activated",              default: false
    t.string   "provider"
    t.string   "uid"
    t.text     "extra_info"
    t.integer  "club_id"
  end

  add_index "users", ["club_id"], name: "index_users_on_club_id"

end
