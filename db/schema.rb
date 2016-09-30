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

ActiveRecord::Schema.define(version: 20160927084959) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cart_items", force: :cascade do |t|
    t.integer  "cart_id"
    t.integer  "product_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "quantity",   default: 1
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.string   "title"
    t.string   "user_name"
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree

  create_table "managers", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_admin",               default: false
  end

  add_index "managers", ["email"], name: "index_managers_on_email", unique: true, using: :btree
  add_index "managers", ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true, using: :btree

  create_table "order_infos", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "shipping_name"
    t.string   "shipping_address"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "postal_code"
    t.string   "phone_number"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "product_name"
    t.integer  "price"
    t.integer  "quantity"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "total",          default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "token"
    t.boolean  "is_paid",        default: false
    t.string   "payment_method"
    t.string   "aasm_state",     default: "order_placed"
    t.string   "order_number"
    t.jsonb    "trade_info",     default: {}
    t.boolean  "undone",         default: false
    t.jsonb    "payment_info"
    t.datetime "deadline"
  end

  add_index "orders", ["aasm_state"], name: "index_orders_on_aasm_state", using: :btree
  add_index "orders", ["order_number"], name: "index_orders_on_order_number", using: :btree
  add_index "orders", ["token"], name: "index_orders_on_token", using: :btree
  add_index "orders", ["trade_info"], name: "index_orders_on_trade_info", using: :btree
  add_index "orders", ["undone"], name: "index_orders_on_undone", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "quantity",    default: 1
    t.integer  "price"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "selling",     default: false
    t.integer  "category_id"
  end

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["selling"], name: "index_products_on_selling", using: :btree

  create_table "trade_infos", force: :cascade do |t|
    t.jsonb    "pay_info",   default: {}
    t.integer  "order_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "trade_infos", ["order_id"], name: "index_trade_infos_on_order_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.jsonb    "info",                   default: {}
    t.boolean  "pre_use_info",           default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["pre_use_info"], name: "index_users_on_pre_use_info", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "trade_infos", "orders"
end
