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

ActiveRecord::Schema[7.0].define(version: 2023_01_31_085444) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "sabeels", force: :cascade do |t|
    t.integer "its", null: false
    t.string "hof_name", null: false
    t.integer "apartment", null: false
    t.integer "flat_no", null: false
    t.string "address", null: false
    t.bigint "mobile", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["hof_name", "its"], name: "index_sabeels_on_hof_name_and_its", unique: true
    t.index ["its"], name: "index_sabeels_on_its", unique: true
    t.index ["slug"], name: "index_sabeels_on_slug", unique: true
  end

  create_table "thaali_takhmeens", force: :cascade do |t|
    t.bigint "sabeel_id", null: false
    t.integer "year", null: false
    t.integer "total", null: false
    t.integer "paid", default: 0, null: false
    t.integer "balance", null: false
    t.boolean "is_complete", default: false, null: false
    t.integer "number", null: false
    t.integer "size", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["sabeel_id"], name: "index_thaali_takhmeens_on_sabeel_id"
    t.index ["slug"], name: "index_thaali_takhmeens_on_slug", unique: true
    t.index ["year", "number"], name: "index_thaali_takhmeens_on_year_and_number", unique: true
    t.index ["year", "sabeel_id"], name: "index_thaali_takhmeens_on_year_and_sabeel_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "thaali_takhmeen_id", null: false
    t.integer "mode", null: false
    t.integer "amount", null: false
    t.date "on_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "recipe_no", null: false
    t.string "slug"
    t.index ["recipe_no"], name: "index_transactions_on_recipe_no"
    t.index ["slug"], name: "index_transactions_on_slug", unique: true
    t.index ["thaali_takhmeen_id"], name: "index_transactions_on_thaali_takhmeen_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "its", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "role", null: false
    t.index ["its"], name: "index_users_on_its", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "thaali_takhmeens", "sabeels"
  add_foreign_key "transactions", "thaali_takhmeens"
end
