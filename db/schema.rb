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

ActiveRecord::Schema[7.0].define(version: 2023_01_26_231421) do
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
    t.string "name", null: false
    t.integer "apartment", null: false
    t.integer "flat_no", null: false
    t.bigint "mobile", null: false
    t.string "email"
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["its"], name: "index_sabeels_on_its", unique: true
    t.index ["slug"], name: "index_sabeels_on_slug", unique: true
  end

  create_table "thaalis", force: :cascade do |t|
    t.bigint "sabeel_id", null: false
    t.integer "year", null: false
    t.integer "total", null: false
    t.integer "number", null: false
    t.integer "size", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sabeel_id"], name: "index_thaalis_on_sabeel_id"
    t.index ["slug"], name: "index_thaalis_on_slug", unique: true
    t.index ["year", "sabeel_id"], name: "index_thaalis_on_year_and_sabeel_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "thaali_id", null: false
    t.integer "recipe_no", null: false
    t.integer "mode", null: false
    t.integer "amount", null: false
    t.date "date", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_no"], name: "index_transactions_on_recipe_no", unique: true
    t.index ["slug"], name: "index_transactions_on_slug", unique: true
    t.index ["thaali_id"], name: "index_transactions_on_thaali_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "its", null: false
    t.integer "role", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["its"], name: "index_users_on_its", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "thaalis", "sabeels"
  add_foreign_key "transactions", "thaalis"
end
