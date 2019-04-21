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

ActiveRecord::Schema.define(version: 2019_04_17_092739) do

  create_table "confirmed_classes", force: :cascade do |t|
    t.integer "teaching_assistant_id"
    t.integer "preference_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "assigned", default: false
    t.index ["preference_id"], name: "index_confirmed_classes_on_preference_id"
    t.index ["teaching_assistant_id"], name: "index_confirmed_classes_on_teaching_assistant_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses_teaching_assistants", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "teaching_assistant_id", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "preferences", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_block_id"
    t.index ["date", "time_block_id"], name: "index_preferences_on_date_and_time_block_id", unique: true
    t.index ["time_block_id"], name: "index_preferences_on_time_block_id"
  end

  create_table "preferences_requests", id: false, force: :cascade do |t|
    t.integer "preference_id", null: false
    t.integer "request_id", null: false
  end

  create_table "preferences_teaching_assistants", id: false, force: :cascade do |t|
    t.integer "preference_id", null: false
    t.integer "teaching_assistant_id", null: false
    t.index ["preference_id", "teaching_assistant_id"], name: "prevent_unavailable_duplicates_1", unique: true
    t.index ["teaching_assistant_id", "preference_id"], name: "prevent_unavailable_duplicates_2", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.text "participants"
    t.text "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "course_id"
    t.integer "confirmed_class_id"
    t.integer "priority", default: 1
    t.boolean "active", default: false
    t.boolean "assigned", default: false
    t.boolean "completed", default: false
    t.index ["confirmed_class_id"], name: "index_requests_on_confirmed_class_id"
    t.index ["course_id"], name: "index_requests_on_course_id"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "teaching_assistants", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teaching_assistants_time_blocks", id: false, force: :cascade do |t|
    t.integer "teaching_assistant_id", null: false
    t.integer "time_block_id", null: false
  end

  create_table "time_blocks", force: :cascade do |t|
    t.integer "day"
    t.time "start"
    t.time "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "google_name"
    t.string "google_email"
    t.string "google_image"
    t.string "google_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
