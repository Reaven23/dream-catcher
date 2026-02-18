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

ActiveRecord::Schema[7.1].define(version: 2026_02_13_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "analyses", force: :cascade do |t|
    t.bigint "dream_id", null: false
    t.text "interpretation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dream_id"], name: "index_analyses_on_dream_id"
  end

  create_table "dreams", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "content"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dreams_on_user_id"
  end

  create_table "global_analyses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "interpretation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dreams_count"
    t.date "first_dream_date"
    t.date "last_dream_date"
    t.index ["user_id"], name: "index_global_analyses_on_user_id"
  end

  create_table "plants", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.string "sun_need"
    t.string "water_need"
    t.string "soil_need"
    t.string "wind_need"
    t.text "other_needs"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "cat_friendly"
    t.index ["user_id"], name: "index_plants_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "zodiac_sign"
    t.integer "age"
    t.string "relationship_status"
    t.string "gender"
    t.string "pays"
    t.string "rappel_reves"
    t.string "reves_lucides"
    t.string "heure_sommeil"
    t.integer "stress_niveau"
    t.string "humeur_generale"
    t.jsonb "source_stress"
    t.string "situation_pro"
    t.jsonb "changements_recents"
    t.string "symbolisme"
    t.string "vision_reves"
    t.text "peurs_principales"
    t.text "emotions_recurrentes"
    t.string "ton_prefere"
    t.string "longueur_analyse"
    t.string "style_prefere"
    t.boolean "onboarding_completed", default: false
    t.datetime "christmas_modal_shown_at"
    t.string "role", default: "new_user", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "analyses", "dreams"
  add_foreign_key "dreams", "users"
  add_foreign_key "global_analyses", "users"
  add_foreign_key "plants", "users"
end
