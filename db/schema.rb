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

ActiveRecord::Schema.define(version: 20151001184116) do

  create_table "alerts", force: :cascade do |t|
    t.string   "name"
    t.text     "expression"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "casts", force: :cascade do |t|
    t.string   "name"
    t.string   "sys"
    t.string   "img_class"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "component_casts", force: :cascade do |t|
    t.integer  "component_id"
    t.integer  "cast_id"
    t.string   "position",     default: "in", null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "components", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "containers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dashboard_widgets", force: :cascade do |t|
    t.integer  "dashboard_id"
    t.integer  "widget_id"
    t.integer  "entity_id"
    t.string   "entity_type"
    t.integer  "refresh_time"
    t.integer  "top"
    t.integer  "left"
    t.integer  "width"
    t.integer  "height"
    t.integer  "limits"
    t.string   "x_axis"
    t.string   "y_axis"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "dashboard_widgets", ["entity_type", "entity_id"], name: "index_dashboard_widgets_on_entity_type_and_entity_id"

  create_table "dashboards", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "execute_details", force: :cascade do |t|
    t.string   "name"
    t.integer  "executable_id"
    t.string   "executable_type"
    t.integer  "rows_count"
    t.boolean  "is_success"
    t.float    "spent_time"
    t.text     "message"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "execute_details", ["executable_type", "executable_id"], name: "index_execute_details_on_executable_type_and_executable_id"

  create_table "reports", force: :cascade do |t|
    t.string   "name"
    t.text     "sql"
    t.text     "regular_expression"
    t.integer  "source_id"
    t.integer  "observations_type",  default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "sys_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schedulers", force: :cascade do |t|
    t.integer  "report_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "last_run_at"
    t.integer  "repeat_every"
    t.integer  "repeat_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.string   "host"
    t.string   "port"
    t.string   "database"
    t.string   "password"
    t.string   "adapter"
    t.string   "encoding"
    t.string   "pool"
    t.string   "destination", default: "database"
    t.string   "path"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.string   "salt"
    t.integer  "role_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "widgets", force: :cascade do |t|
    t.string   "name"
    t.string   "sys"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
