# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2019_05_18_224054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "confirmed_classes", force: :cascade do |t|
    t.bigint "teaching_assistant_id"
    t.bigint "preference_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "assigned", default: false
    t.boolean "confirmed", default: false
    t.uuid "slug", default: -> { "gen_random_uuid()" }, null: false
    t.index ["preference_id"], name: "index_confirmed_classes_on_preference_id"
    t.index ["teaching_assistant_id"], name: "index_confirmed_classes_on_teaching_assistant_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "courses_teaching_assistants", id: false, force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "teaching_assistant_id", null: false
    t.index ["course_id", "teaching_assistant_id"], name: "course and TA index"
    t.index ["course_id"], name: "index_courses_teaching_assistants_on_course_id"
    t.index ["teaching_assistant_id"], name: "index_courses_teaching_assistants_on_teaching_assistant_id"
  end

  create_table "identities", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "time_block_id"
    t.index ["date", "time_block_id"], name: "index_preferences_on_date_and_time_block_id", unique: true
    t.index ["time_block_id"], name: "index_preferences_on_time_block_id"
  end

  create_table "preferences_requests", id: false, force: :cascade do |t|
    t.bigint "preference_id", null: false
    t.bigint "request_id", null: false
    t.index ["preference_id", "request_id"], name: "index_preferences_requests_on_preference_id_and_request_id"
    t.index ["preference_id"], name: "index_preferences_requests_on_preference_id"
    t.index ["request_id"], name: "index_preferences_requests_on_request_id"
  end

  create_table "preferences_teaching_assistants", id: false, force: :cascade do |t|
    t.bigint "preference_id", null: false
    t.bigint "teaching_assistant_id", null: false
    t.index ["preference_id", "teaching_assistant_id"], name: "prevent_unavailable_duplicates_1", unique: true
    t.index ["preference_id"], name: "index_preferences_teaching_assistants_on_preference_id"
    t.index ["teaching_assistant_id", "preference_id"], name: "prevent_unavailable_duplicates_2", unique: true
    t.index ["teaching_assistant_id"], name: "index_preferences_teaching_assistants_on_teaching_assistant_id"
  end

  create_table "requests", force: :cascade do |t|
    t.text "contents"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.bigint "course_id"
    t.bigint "confirmed_class_id"
    t.integer "priority", default: 1
    t.boolean "active", default: false
    t.boolean "assigned", default: false
    t.boolean "completed", default: false
    t.string "participants", default: [], array: true
    t.index ["confirmed_class_id"], name: "index_requests_on_confirmed_class_id"
    t.index ["course_id"], name: "index_requests_on_course_id"
    t.index ["participants"], name: "index_requests_on_participants", using: :gin
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "teaching_assistants", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "teaching_assistants_time_blocks", id: false, force: :cascade do |t|
    t.bigint "teaching_assistant_id", null: false
    t.bigint "time_block_id", null: false
    t.index ["teaching_assistant_id", "time_block_id"], name: "TA and block index"
    t.index ["teaching_assistant_id"], name: "index_teaching_assistants_time_blocks_on_teaching_assistant_id"
    t.index ["time_block_id"], name: "index_teaching_assistants_time_blocks_on_time_block_id"
  end

  create_table "time_blocks", force: :cascade do |t|
    t.integer "day"
    t.time "start"
    t.time "finish"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "google_name"
    t.string "google_email"
    t.string "google_image"
    t.string "google_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "role", default: "student"
  end

  add_foreign_key "confirmed_classes", "preferences"
  add_foreign_key "confirmed_classes", "teaching_assistants"
  add_foreign_key "preferences", "time_blocks"
  add_foreign_key "requests", "confirmed_classes"
  add_foreign_key "requests", "courses"
  add_foreign_key "requests", "users"
end
