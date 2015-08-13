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

ActiveRecord::Schema.define(version: 20150812202734) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "clubs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "website",    limit: 255
    t.string   "img",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.text     "body",         limit: 65535
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "micropost_id", limit: 4
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "title",      limit: 255
    t.text     "content",    limit: 65535
    t.integer  "club_id",    limit: 4
    t.datetime "date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "content",    limit: 65535
    t.integer  "club_id",    limit: 4
    t.integer  "holes",      limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "holes", force: :cascade do |t|
    t.integer  "course_id",  limit: 4
    t.integer  "number",     limit: 4
    t.integer  "par",        limit: 4
    t.integer  "length",     limit: 4
    t.integer  "tee_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text     "content",     limit: 65535
    t.string   "heading",     limit: 255
    t.text     "desc",        limit: 65535
    t.integer  "user_id",     limit: 4
    t.integer  "category_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rounds", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "course_id",      limit: 4
    t.integer  "competition_id", limit: 4
    t.integer  "tee_id",         limit: 4
    t.integer  "tour_part_id",   limit: 4
    t.integer  "score",          limit: 4
    t.integer  "division_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "round_id",   limit: 4
    t.integer  "tee_id",     limit: 4
    t.integer  "hole_id",    limit: 4
    t.integer  "score",      limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "tees", force: :cascade do |t|
    t.string   "color",      limit: 255
    t.integer  "par",        limit: 4
    t.integer  "course_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tour_parts", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.text     "content",        limit: 65535
    t.integer  "course_id",      limit: 4
    t.integer  "competition_id", limit: 4
    t.integer  "tee_id",         limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "date"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest", limit: 255
    t.string   "remember_digest", limit: 255
    t.integer  "club_id",         limit: 4
    t.boolean  "admin",           limit: 1
  end

end
