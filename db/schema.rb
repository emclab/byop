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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120220190020) do

  create_table "comm_logs", :force => true do |t|
    t.string   "subject"
    t.string   "via"
    t.string   "contact_with"
    t.string   "purpose"
    t.text     "log"
    t.integer  "input_by_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.text     "contact_info"
    t.string   "address"
    t.string   "country"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
    t.string   "web"
    t.boolean  "active",          :default => true
    t.integer  "input_by_id"
    t.string   "quality_system"
    t.string   "employee_num"
    t.string   "revenue"
    t.text     "main_biz"
    t.text     "equip_by_by"
    t.text     "installed_equip"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "src_plants", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "address"
    t.string   "primary_contact"
    t.string   "primary_cell"
    t.string   "phone"
    t.string   "tech_contact"
    t.string   "tech_cell"
    t.text     "tech_ability"
    t.text     "customer_service"
    t.text     "production_capacity"
    t.text     "sourced_product"
    t.text     "equip"
    t.date     "last_eval_date"
    t.text     "eval_summary"
    t.string   "quality_system"
    t.string   "employee_num"
    t.boolean  "active",              :default => true
    t.string   "revenue"
    t.date     "src_since"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "input_by_id"
    t.string   "web"
    t.string   "email"
    t.string   "fax"
    t.text     "main_product"
  end

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "contact"
    t.string   "phone"
    t.string   "cell"
    t.string   "address"
    t.string   "web"
    t.text     "product_supplied"
    t.integer  "input_by_id"
    t.text     "main_product"
    t.date     "supply_since"
    t.date     "last_eval_date"
    t.text     "eval_summary"
    t.text     "customer_service"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",           :default => true
    t.string   "fax"
    t.string   "email"
    t.string   "quality_system"
    t.date     "date_since"
  end

  create_table "user_levels", :force => true do |t|
    t.integer  "user_id"
    t.string   "role"
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "status",             :default => "active"
    t.string   "user_type"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
