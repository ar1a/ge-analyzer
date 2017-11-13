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

ActiveRecord::Schema.define(version: 20171113044335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favourites", force: :cascade do |t|
    t.integer "user_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_favourites_on_item_id"
    t.index ["user_id", "item_id"], name: "index_favourites_on_user_id_and_item_id", unique: true
    t.index ["user_id"], name: "index_favourites_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "runescape_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
    t.datetime "last_update_time"
    t.decimal "roi"
    t.integer "buying_rate"
    t.integer "selling_rate"
    t.decimal "recommended_buy_price"
    t.decimal "recommended_sell_price"
    t.integer "margin"
    t.boolean "members", default: true
    t.index ["buying_rate"], name: "index_items_on_buying_rate"
    t.index ["margin"], name: "index_items_on_margin"
    t.index ["members"], name: "index_items_on_members"
    t.index ["name"], name: "index_items_on_name"
    t.index ["recommended_buy_price"], name: "index_items_on_recommended_buy_price"
    t.index ["recommended_sell_price"], name: "index_items_on_recommended_sell_price"
    t.index ["roi"], name: "index_items_on_roi"
    t.index ["runescape_id"], name: "index_items_on_runescape_id"
    t.index ["selling_rate"], name: "index_items_on_selling_rate"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "price_updates", force: :cascade do |t|
    t.integer "buy_average"
    t.integer "sell_average"
    t.integer "overall_average"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "roi"
    t.index ["created_at"], name: "index_price_updates_on_created_at"
    t.index ["item_id"], name: "index_price_updates_on_item_id"
    t.index ["roi"], name: "index_price_updates_on_roi"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.jsonb "settings", default: {}, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
