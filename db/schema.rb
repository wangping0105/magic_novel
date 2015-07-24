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
    t.integer  "book_id",        limit: 4
    t.integer  "book_volume_id", limit: 4
    t.string   "title",          limit: 255
    t.text     "content",        limit: 65535
    t.integer  "word_count",     limit: 4
    t.integer  "is_free",        limit: 4
    t.integer  "types",          limit: 4
    t.decimal  "price",                        precision: 10
    t.float    "discount",       limit: 24
    t.datetime "deleted_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "book_chapters", ["book_id"], name: "index_book_chapters_on_book_id", using: :btree
  add_index "book_chapters", ["book_volume_id"], name: "index_book_chapters_on_book_volume_id", using: :btree

  create_table "book_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "book_count", limit: 4
    t.string   "remarks",    limit: 255
    t.string   "pinyin",     limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "book_volumes", force: :cascade do |t|
    t.integer  "book_id",            limit: 4
    t.string   "title",              limit: 255
    t.integer  "book_chapter_count", limit: 4
    t.integer  "is_free",            limit: 4
    t.decimal  "price",                          precision: 10
    t.float    "discount",           limit: 24
    t.datetime "deleted_at"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "book_volumes", ["book_id"], name: "index_book_volumes_on_book_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "pinyin",             limit: 255
    t.integer  "author_id",          limit: 4
    t.integer  "book_type_id",       limit: 4
    t.text     "introduction",       limit: 65535
    t.string   "remarks",            limit: 255
    t.integer  "tag_id",             limit: 4
    t.integer  "status",             limit: 4
    t.decimal  "total_price",                      precision: 10
    t.float    "discount",           limit: 24
    t.integer  "words",              limit: 4
    t.integer  "click_count",        limit: 4
    t.integer  "recommend_count",    limit: 4
    t.integer  "collection_count",   limit: 4
    t.integer  "book_volume_count",  limit: 4
    t.integer  "book_chapter_count", limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id", using: :btree
  add_index "books", ["book_type_id"], name: "index_books_on_book_type_id", using: :btree
  add_index "books", ["tag_id"], name: "index_books_on_tag_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255
    t.string   "name",                 limit: 255
    t.datetime "activated"
    t.boolean  "admin",                limit: 1,   default: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "authentication_token", limit: 255
    t.string   "password_digest",      limit: 255
    t.integer  "deleted_at",           limit: 4
  end

end
