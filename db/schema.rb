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

ActiveRecord::Schema.define(version: 20170129110920) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.integer  "company_id"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_announcements_on_company_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slack_id"
    t.text     "slack_access_token"
    t.string   "slack_bot_user_id"
    t.text     "slack_bot_access_token"
  end

  create_table "employments", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email"
    t.string   "slack_handle"
    t.string   "slack_id"
    t.boolean  "archived",            default: false
    t.string   "slack_dm_channel_id"
    t.string   "time_zone"
    t.index ["company_id"], name: "index_employments_on_company_id", using: :btree
    t.index ["user_id"], name: "index_employments_on_user_id", using: :btree
  end

  create_table "inquiries", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "employment_id"
    t.datetime "to_be_delivered_at"
    t.datetime "delivered_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["employment_id"], name: "index_inquiries_on_employment_id", using: :btree
    t.index ["question_id"], name: "index_inquiries_on_question_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_questions_on_company_id", using: :btree
  end

  create_table "responses", force: :cascade do |t|
    t.text     "text"
    t.integer  "employment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["employment_id"], name: "index_responses_on_employment_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "announcements", "companies"
  add_foreign_key "employments", "companies"
  add_foreign_key "employments", "users"
  add_foreign_key "inquiries", "employments"
  add_foreign_key "inquiries", "questions"
  add_foreign_key "questions", "companies"
  add_foreign_key "responses", "employments"
end
