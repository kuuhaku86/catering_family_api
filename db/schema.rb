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

ActiveRecord::Schema.define(version: 2022_04_15_083102) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories_menus", force: :cascade do |t|
    t.integer "menu_id"
    t.integer "category_id"
    t.index ["category_id"], name: "index_categories_menus_on_category_id"
    t.index ["menu_id", "category_id"], name: "index_menus_categories_on_menu_id_and_category_id", unique: true
    t.index ["menu_id"], name: "index_categories_menus_on_menu_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", force: :cascade do |t|
    t.float "total_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "customer_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  create_table "orders_menus", force: :cascade do |t|
    t.integer "quantity"
    t.float "total_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "orders_id"
    t.integer "menus_id"
    t.index "\"order_id\", \"menu_id\"", name: "index_orders_menus_on_order_id_and_menu_id", unique: true
    t.index ["menus_id"], name: "index_orders_menus_on_menus_id"
    t.index ["orders_id"], name: "index_orders_menus_on_orders_id"
  end

  add_foreign_key "orders", "customers"
  add_foreign_key "orders_menus", "menus", column: "menus_id"
  add_foreign_key "orders_menus", "orders", column: "orders_id"
end
