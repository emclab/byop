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

ActiveRecord::Schema.define(:version => 20120731224025) do

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

  create_table "installation_logs", :force => true do |t|
    t.integer  "installation_id"
    t.text     "log"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "installation_purchase_logs", :force => true do |t|
    t.integer  "installation_purchase_id"
    t.integer  "input_by_id"
    t.text     "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "installation_purchases", :force => true do |t|
    t.integer  "installation_id"
    t.integer  "input_by_id"
    t.integer  "applicant_id"
    t.string   "part_name"
    t.string   "spec"
    t.integer  "qty"
    t.string   "unit"
    t.decimal  "unit_price"
    t.decimal  "total"
    t.text     "for_what"
    t.integer  "qty_purchased"
    t.decimal  "total_paid"
    t.integer  "qty_in_stock"
    t.boolean  "approved_by_vp_eng"
    t.integer  "approve_vp_eng_id"
    t.date     "approve_date_vp_eng"
    t.boolean  "approved_by_ceo"
    t.integer  "approve_ceo_id"
    t.date     "approve_date_ceo"
    t.string   "storage_location"
    t.boolean  "purchased",           :default => false
    t.date     "need_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "warehoused",          :default => false
  end

  create_table "installations", :force => true do |t|
    t.string   "install_name"
    t.date     "start_date"
    t.date     "finish_date"
    t.integer  "input_by_id"
    t.boolean  "completed",    :default => false
    t.integer  "inst_eng_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "manufacturers", :force => true do |t|
    t.string   "name"
    t.integer  "input_by_id"
    t.string   "product"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "out_logs", :force => true do |t|
    t.datetime "out_date"
    t.integer  "receiver_id"
    t.integer  "out_qty"
    t.integer  "project_id"
    t.string   "for_what"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "input_by_id"
    t.integer  "part_id"
  end

  create_table "parts", :force => true do |t|
    t.string   "name"
    t.datetime "in_date"
    t.integer  "in_qty"
    t.string   "spec"
    t.integer  "input_by_id"
    t.integer  "stock_qty"
    t.string   "manufacturer"
    t.text     "note"
    t.string   "storage_location"
    t.string   "inspection"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unit"
    t.string   "supplier"
  end

  create_table "payment_logs", :force => true do |t|
    t.date     "pay_date"
    t.integer  "sourcing_id"
    t.integer  "purchasing_id"
    t.decimal  "amount",        :precision => 10, :scale => 2, :default => 0.0
    t.string   "short_note"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "production_logs", :force => true do |t|
    t.integer  "production_id"
    t.text     "log"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "productions", :force => true do |t|
    t.string   "name"
    t.text     "desp"
    t.integer  "project_id"
    t.date     "start_date"
    t.date     "finish_date"
    t.integer  "eng_id"
    t.boolean  "completed",   :default => false
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "proj_modules", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_logs", :force => true do |t|
    t.text     "log"
    t.integer  "input_by_id"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "customer_id"
    t.text     "customer_contact_info"
    t.string   "status"
    t.string   "install_address"
    t.decimal  "budget"
    t.string   "tonnage"
    t.text     "tech_spec"
    t.text     "subsys_spec"
    t.text     "other_tech_requirement"
    t.text     "turn_over_requirement"
    t.date     "bid_doc_available_date"
    t.date     "bid_deadline"
    t.date     "bid_opening_date"
    t.date     "contract_date"
    t.date     "production_start_date"
    t.date     "construction_finish_date"
    t.date     "install_start_date"
    t.boolean  "completed",                :default => false
    t.boolean  "cancelled",                :default => false
    t.text     "note"
    t.text     "review_after"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "awarded"
    t.date     "design_start_date"
    t.datetime "cancel_date"
  end

  create_table "purchasing_logs", :force => true do |t|
    t.integer  "purchasing_id"
    t.text     "log"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchasings", :force => true do |t|
    t.string   "prod_name"
    t.string   "part_num"
    t.string   "spec"
    t.integer  "project_id"
    t.integer  "qty"
    t.string   "unit"
    t.decimal  "unit_price"
    t.integer  "pur_eng_id"
    t.integer  "manufacturer_id"
    t.integer  "supplier_id"
    t.date     "order_date"
    t.date     "delivery_date"
    t.boolean  "delivered",                                            :default => false
    t.integer  "proj_module_id"
    t.integer  "input_by_id"
    t.boolean  "approved_by_eng"
    t.integer  "approve_eng_id"
    t.date     "approve_date_eng"
    t.boolean  "approved_by_vp_eng"
    t.integer  "approve_vp_eng_id"
    t.date     "approve_date_vp_eng"
    t.boolean  "approved_by_pur_eng"
    t.integer  "approve_pur_eng_id"
    t.date     "approve_date_pur_eng"
    t.boolean  "approved_by_ceo"
    t.integer  "approve_ceo_id"
    t.date     "approve_date_ceo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "eng_id"
    t.decimal  "total",                 :precision => 10, :scale => 2
    t.date     "actual_receiving_date"
  end

  create_table "quality_issues", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.date     "report_date"
    t.integer  "report_by_id"
    t.text     "issue_desp"
    t.text     "root_cause"
    t.text     "quick_fix"
    t.text     "solution"
    t.text     "preventative_action"
    t.boolean  "case_closed",         :default => false
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "customer_feedback"
    t.date     "close_date"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "sourcing_logs", :force => true do |t|
    t.integer  "sourcing_id"
    t.text     "log"
    t.integer  "input_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sourcings", :force => true do |t|
    t.string   "prod_name"
    t.string   "part_num"
    t.text     "spec"
    t.integer  "qty"
    t.string   "unit"
    t.decimal  "unit_price"
    t.integer  "proj_module_id"
    t.integer  "src_plant_id"
    t.date     "start_date"
    t.date     "finish_date"
    t.boolean  "completed",                                          :default => false
    t.integer  "src_eng_id"
    t.integer  "input_by_id"
    t.boolean  "approved_by_vp_eng"
    t.integer  "approve_vp_eng_id"
    t.date     "approve_date_vp_eng"
    t.boolean  "approved_by_ceo"
    t.integer  "approve_ceo_id"
    t.date     "approve_date_ceo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.integer  "eng_id"
    t.decimal  "total",               :precision => 10, :scale => 2
  end

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
  end

  create_table "sys_logs", :force => true do |t|
    t.datetime "log_date"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_ip"
    t.string   "action_logged"
  end

  add_index "sys_logs", ["user_id"], :name => "index_sys_logs_on_user_id"
  add_index "sys_logs", ["user_ip"], :name => "index_sys_logs_on_user_ip"

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
