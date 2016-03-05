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

ActiveRecord::Schema.define(version: 20160303223732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  add_index "dashboard_widgets", ["entity_type", "entity_id"], name: "index_dashboard_widgets_on_entity_type_and_entity_id", using: :btree

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

  add_index "execute_details", ["executable_type", "executable_id"], name: "index_execute_details_on_executable_type_and_executable_id", using: :btree

  create_table "report_13_observations", id: false, force: :cascade do |t|
    t.string "date", limit: 255
    t.string "a2",   limit: 255
    t.string "a3",   limit: 255
    t.string "a4",   limit: 255
    t.string "a5",   limit: 255
    t.string "a6",   limit: 255
    t.string "a7",   limit: 255
    t.string "a8",   limit: 255
  end

  create_table "report_19_observations", id: false, force: :cascade do |t|
    t.string "column0",  limit: 255
    t.string "column1",  limit: 255
    t.string "column2",  limit: 255
    t.string "column3",  limit: 255
    t.string "column4",  limit: 255
    t.string "column5",  limit: 255
    t.string "column6",  limit: 255
    t.string "column7",  limit: 255
    t.string "column8",  limit: 255
    t.string "column9",  limit: 255
    t.string "column10", limit: 255
    t.string "column11", limit: 255
    t.string "column12", limit: 255
    t.string "column13", limit: 255
    t.string "column14", limit: 255
    t.string "column15", limit: 255
    t.string "column16", limit: 255
    t.string "column17", limit: 255
    t.string "column18", limit: 255
    t.string "column19", limit: 255
  end

  create_table "report_1_observations", id: false, force: :cascade do |t|
    t.string "column0", limit: 255
    t.string "column1", limit: 255
    t.string "column2", limit: 255
    t.string "column3", limit: 255
  end

  create_table "report_20_observations", id: false, force: :cascade do |t|
    t.string "column0", limit: 255
    t.string "column1", limit: 255
    t.string "column2", limit: 255
    t.string "column3", limit: 255
  end

  create_table "report_2_observations", id: false, force: :cascade do |t|
    t.string "column0",  limit: 255
    t.string "column1",  limit: 255
    t.string "column2",  limit: 255
    t.string "column3",  limit: 255
    t.string "column4",  limit: 255
    t.string "column5",  limit: 255
    t.string "column6",  limit: 255
    t.string "column7",  limit: 255
    t.string "column8",  limit: 255
    t.string "column9",  limit: 255
    t.string "column10", limit: 255
    t.string "column11", limit: 255
    t.string "column12", limit: 255
    t.string "column13", limit: 255
    t.string "column14", limit: 255
    t.string "column15", limit: 255
    t.string "column16", limit: 255
    t.string "column17", limit: 255
    t.string "column18", limit: 255
    t.string "column19", limit: 255
  end

  create_table "report_3_observations", id: false, force: :cascade do |t|
    t.string "column0", limit: 255
    t.string "column1", limit: 255
    t.string "column2", limit: 255
    t.string "column3", limit: 255
    t.string "column4", limit: 255
  end

  create_table "report_7_observations", id: false, force: :cascade do |t|
    t.string "column0", limit: 255
    t.string "column1", limit: 255
    t.string "column2", limit: 255
    t.string "column3", limit: 255
    t.string "column4", limit: 255
    t.string "column5", limit: 255
    t.string "column6", limit: 255
    t.string "column7", limit: 255
  end

  create_table "report_8_observations", id: false, force: :cascade do |t|
    t.string "column0",  limit: 255
    t.string "column1",  limit: 255
    t.string "column2",  limit: 255
    t.string "column3",  limit: 255
    t.string "column4",  limit: 255
    t.string "column5",  limit: 255
    t.string "column6",  limit: 255
    t.string "column7",  limit: 255
    t.string "column8",  limit: 255
    t.string "column9",  limit: 255
    t.string "column10", limit: 255
    t.string "column11", limit: 255
    t.string "column12", limit: 255
    t.string "column13", limit: 255
    t.string "column14", limit: 255
    t.string "column15", limit: 255
    t.string "column16", limit: 255
    t.string "column17", limit: 255
    t.string "column18", limit: 255
    t.string "column19", limit: 255
    t.string "column20", limit: 255
    t.string "column21", limit: 255
    t.string "column22", limit: 255
    t.string "column23", limit: 255
    t.string "column24", limit: 255
    t.string "column25", limit: 255
  end

  create_table "report_9_observations", id: false, force: :cascade do |t|
    t.string "column0", limit: 255
    t.string "column1", limit: 255
    t.string "column2", limit: 255
    t.string "column3", limit: 255
    t.string "column4", limit: 255
    t.string "column5", limit: 255
  end

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
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "role_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "is_active",       default: false
  end

  create_table "widgets", force: :cascade do |t|
    t.string   "name"
    t.string   "sys"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
