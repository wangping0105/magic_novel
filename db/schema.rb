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

ActiveRecord::Schema.define(version: 20150723143532) do

  create_table "book_chapters", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "book_volume_id"
    t.string   "title"
    t.text     "content"
    t.integer  "word_count"
    t.integer  "is_free"
    t.integer  "types"
    t.decimal  "price"
    t.float    "discount"
    t.datetime "deleted_at"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "book_chapters", ["book_id"], name: "index_book_chapters_on_book_id"
  add_index "book_chapters", ["book_volume_id"], name: "index_book_chapters_on_book_volume_id"

  create_table "book_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "book_count"
    t.string   "remarks"
    t.string   "pinyin"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_volumes", force: :cascade do |t|
    t.integer  "book_id"
    t.string   "title"
    t.integer  "book_chapter_count"
    t.integer  "is_free"
    t.decimal  "price"
    t.float    "discount"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "book_volumes", ["book_id"], name: "index_book_volumes_on_book_id"

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "pinyin"
    t.integer  "author_id"
    t.integer  "book_type_id"
    t.text     "introduction"
    t.string   "remarks"
    t.integer  "tag_id"
    t.integer  "status"
    t.decimal  "total_price"
    t.float    "discount"
    t.integer  "words"
    t.integer  "click_count"
    t.integer  "recommend_count"
    t.integer  "collection_count"
    t.integer  "book_volume_count"
    t.integer  "book_chapter_count"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id"
  add_index "books", ["book_type_id"], name: "index_books_on_book_type_id"
  add_index "books", ["tag_id"], name: "index_books_on_tag_id"

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.datetime "activated"
    t.boolean  "admin",                default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "authentication_token"
    t.string   "password_digest"
    t.integer  "deleted_at"
  end

end
