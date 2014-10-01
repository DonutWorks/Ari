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

ActiveRecord::Schema.define(version: 20140928122400) do

  create_table "account_activations", force: true do |t|
    t.integer  "user_id"
    t.boolean  "activated",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "provider_token_id"
  end

  add_index "account_activations", ["user_id"], name: "index_account_activations_on_user_id"

  create_table "activation_tickets", force: true do |t|
    t.string   "code"
    t.integer  "account_activation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activation_tickets", ["account_activation_id"], name: "index_activation_tickets_on_account_activation_id"

  create_table "gates", force: true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "link"
    t.datetime "duedate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortenURL"
  end

  create_table "provider_tokens", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "read_activity_marks", force: true do |t|
    t.integer  "reader_id",                 null: false
    t.integer  "readable_id"
    t.string   "readable_type"
    t.integer  "mark",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",               null: false
    t.string   "phone_number"
    t.string   "major"
    t.float    "generation_id",          limit: 255
    t.string   "student_id"
    t.string   "sex"
    t.string   "home_phone_number"
    t.string   "emergency_phone_number"
    t.string   "habitat_id"
    t.string   "member_type"
    t.string   "birth"
  end

end
