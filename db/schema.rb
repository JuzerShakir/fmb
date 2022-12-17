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

ActiveRecord::Schema[7.0].define(version: 2022_12_16_145934) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sabeels", force: :cascade do |t|
    t.integer "its", null: false
    t.string "hof_name", null: false
    t.integer "building_name", null: false
    t.string "wing", null: false
    t.integer "flat_no", null: false
    t.string "address", null: false
    t.bigint "mobile", null: false
    t.string "email"
    t.boolean "takes_thaali", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hof_name", "its"], name: "index_sabeels_on_hof_name_and_its", unique: true
    t.index ["its"], name: "index_sabeels_on_its", unique: true
  end

  create_table "thaalis", force: :cascade do |t|
    t.integer "number", null: false
    t.integer "size", null: false
    t.bigint "sabeel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_thaalis_on_number", unique: true
    t.index ["sabeel_id"], name: "index_thaalis_on_sabeel_id", unique: true
  end

  add_foreign_key "thaalis", "sabeels"
end
