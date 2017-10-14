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

ActiveRecord::Schema.define(version: 20171014151313) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "coordinates"
    t.decimal "rating"
    t.integer "rating_number"
    t.string "postalcode"
    t.string "district"
    t.string "area"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id"
    t.index ["business_id"], name: "index_branches_on_business_id"
  end

  create_table "business_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "businesses", force: :cascade do |t|
    t.string "name"
    t.bigint "business_category_id"
    t.index ["business_category_id"], name: "index_businesses_on_business_category_id"
  end

  create_table "crowd_levels", force: :cascade do |t|
    t.integer "hour"
    t.string "day"
    t.integer "density"
    t.bigint "branch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_crowd_levels_on_branch_id"
  end

  add_foreign_key "branches", "businesses"
  add_foreign_key "businesses", "business_categories"
  add_foreign_key "crowd_levels", "branches"
end
