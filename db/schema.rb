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

ActiveRecord::Schema.define(version: 20141108070246) do

  create_table "activities", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "activity_type"
    t.datetime "event_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assign_histories", force: true do |t|
    t.integer  "user_id"
    t.integer  "checklist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assign_histories", ["checklist_id"], name: "index_assign_histories_on_checklist_id"
  add_index "assign_histories", ["user_id"], name: "index_assign_histories_on_user_id"

  create_table "assignee_comments", force: true do |t|
    t.text     "comment"
    t.integer  "checklist_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignee_comments", ["checklist_id"], name: "index_assignee_comments_on_checklist_id"

  create_table "bank_accounts", force: true do |t|
    t.string   "account_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checklists", force: true do |t|
    t.text     "task"
    t.boolean  "finish"
    t.integer  "notice_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklists", ["finish"], name: "index_checklists_on_finish"
  add_index "checklists", ["notice_id"], name: "index_checklists_on_notice_id"

  create_table "expense_records", force: true do |t|
    t.datetime "record_date"
    t.integer  "deposit"
    t.integer  "withdraw"
    t.string   "content"
    t.boolean  "confirm"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bank_account_id"
  end

  add_index "expense_records", ["bank_account_id"], name: "index_expense_records_on_bank_account_id"

  create_table "invitations", force: true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "expired",    default: false
    t.integer  "user_id"
  end

  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id"

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
  end

  add_index "messages", ["notice_id"], name: "index_messages_on_notice_id"

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
    t.integer  "regular_dues"
    t.integer  "associate_dues"
    t.integer  "activity_id"
    t.datetime "event_at"
  end

  add_index "notices", ["activity_id"], name: "index_notices_on_activity_id"
  add_index "notices", ["notice_type"], name: "index_notices_on_notice_type"

  create_table "read_activity_marks", force: true do |t|
    t.integer  "reader_id",                 null: false
    t.integer  "readable_id"
    t.string   "readable_type"
    t.integer  "mark",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "read_activity_marks", ["readable_id"], name: "index_read_activity_marks_on_readable_id"
  add_index "read_activity_marks", ["readable_type"], name: "index_read_activity_marks_on_readable_type"
  add_index "read_activity_marks", ["reader_id"], name: "index_read_activity_marks_on_reader_id"

  create_table "responses", force: true do |t|
    t.integer  "user_id"
    t.integer  "notice_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "absence",    default: 0
    t.integer  "dues",       default: 0
    t.string   "memo"
  end

  add_index "responses", ["notice_id"], name: "index_responses_on_notice_id"
  add_index "responses", ["user_id"], name: "index_responses_on_user_id"

  create_table "taggings", force: true do |t|
    t.integer  "user_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id"
  add_index "taggings", ["user_id"], name: "index_taggings_on_user_id"

  create_table "tags", force: true do |t|
    t.string   "tag_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["phone_number"], name: "index_users_on_phone_number"
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["uid"], name: "index_users_on_uid"

end
