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

ActiveRecord::Schema.define(version: 20161208085613) do

  create_table "attachments", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "attachmentable_id",   limit: 4
    t.string   "attachmentable_type", limit: 255
    t.string   "name",                limit: 255
    t.string   "file_file_name",      limit: 255
    t.string   "file_content_type",   limit: 255
    t.integer  "file_file_size",      limit: 4
    t.datetime "file_updated_at"
    t.datetime "deleted_at"
    t.text     "note",                limit: 65535
    t.string   "sub_type",            limit: 255
    t.integer  "attachment_position", limit: 4
    t.string   "qiniu_persistent_id", limit: 255
    t.datetime "updated_at",                        null: false
    t.datetime "created_at",                        null: false
  end

  add_index "attachments", ["attachmentable_id", "attachmentable_type"], name: "index_attachments_on_attachmentable_id_and_attachmentable_type", using: :btree
  add_index "attachments", ["qiniu_persistent_id"], name: "index_attachments_on_qiniu_persistent_id", using: :btree
  add_index "attachments", ["user_id"], name: "index_attachments_on_user_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "user_id",         limit: 4
    t.integer  "reprint_user_id", limit: 4
    t.integer  "books_count",     limit: 4,   default: 0
    t.integer  "level",           limit: 4,   default: 0
    t.boolean  "is_identity",     limit: 1,   default: false
    t.integer  "experience",      limit: 4,   default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "authors", ["reprint_user_id"], name: "index_authors_on_reprint_user_id", using: :btree
  add_index "authors", ["user_id"], name: "index_authors_on_user_id", using: :btree

  create_table "book_chapters", force: :cascade do |t|
    t.integer  "book_id",         limit: 4
    t.integer  "book_volume_id",  limit: 4
    t.string   "title",           limit: 255
    t.text     "content",         limit: 65535
    t.integer  "word_count",      limit: 4
    t.integer  "next_chapter_id", limit: 4
    t.integer  "prev_chapter_id", limit: 4
    t.integer  "is_free",         limit: 4
    t.integer  "types",           limit: 4
    t.decimal  "price",                         precision: 10
    t.float    "discount",        limit: 24
    t.datetime "deleted_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "book_chapters", ["book_id"], name: "index_book_chapters_on_book_id", using: :btree
  add_index "book_chapters", ["book_volume_id"], name: "index_book_chapters_on_book_volume_id", using: :btree

  create_table "book_marks", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.integer  "book_id",         limit: 4
    t.integer  "book_chapter_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "book_marks", ["book_chapter_id"], name: "index_book_marks_on_book_chapter_id", using: :btree
  add_index "book_marks", ["book_id"], name: "index_book_marks_on_book_id", using: :btree
  add_index "book_marks", ["user_id"], name: "index_book_marks_on_user_id", using: :btree

  create_table "book_relations", force: :cascade do |t|
    t.integer  "book_id",       limit: 4
    t.integer  "user_id",       limit: 4
    t.integer  "relation_type", limit: 4, default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "book_relations", ["book_id"], name: "index_book_relations_on_book_id", using: :btree
  add_index "book_relations", ["user_id"], name: "index_book_relations_on_user_id", using: :btree

  create_table "book_tag_relations", force: :cascade do |t|
    t.integer  "book_id",    limit: 4
    t.integer  "tag_id",     limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "book_tag_relations", ["book_id"], name: "index_book_tag_relations_on_book_id", using: :btree
  add_index "book_tag_relations", ["tag_id"], name: "index_book_tag_relations_on_tag_id", using: :btree

  create_table "book_volumes", force: :cascade do |t|
    t.integer  "book_id",             limit: 4
    t.string   "title",               limit: 255
    t.integer  "book_chapters_count", limit: 4,                  default: 0
    t.integer  "is_free",             limit: 4
    t.decimal  "price",                           precision: 10
    t.float    "discount",            limit: 24
    t.integer  "next_volume_id",      limit: 4
    t.integer  "prev_volume_id",      limit: 4
    t.datetime "deleted_at"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
  end

  add_index "book_volumes", ["book_id"], name: "index_book_volumes_on_book_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string   "title",               limit: 255
    t.string   "pinyin",              limit: 255
    t.integer  "author_id",           limit: 4
    t.integer  "book_type",           limit: 4
    t.text     "introduction",        limit: 65535
    t.string   "remarks",             limit: 255
    t.integer  "status",              limit: 4,                    default: 0
    t.decimal  "total_price",                       precision: 10
    t.float    "discount",            limit: 24
    t.integer  "words",               limit: 4
    t.integer  "click_count",         limit: 4,                    default: 0
    t.integer  "recommend_count",     limit: 4,                    default: 0
    t.integer  "collection_count",    limit: 4,                    default: 0
    t.integer  "book_volumes_count",  limit: 4,                    default: 0
    t.integer  "book_chapters_count", limit: 4,                    default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "classification_id",   limit: 4
    t.integer  "operator_id",         limit: 4
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id", using: :btree
  add_index "books", ["book_type"], name: "index_books_on_book_type", using: :btree

  create_table "classifications", force: :cascade do |t|
    t.integer  "parent_id",   limit: 4
    t.string   "name",        limit: 255
    t.string   "pinyin",      limit: 255
    t.string   "remark",      limit: 255
    t.integer  "books_count", limit: 4,   default: 0
    t.datetime "dalete_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "classifications", ["parent_id"], name: "index_classifications_on_parent_id", using: :btree
  add_index "classifications", ["pinyin"], name: "index_classifications_on_pinyin", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.string   "title",            limit: 255
    t.text     "body",             limit: 65535
    t.integer  "user_id",          limit: 4
    t.integer  "subject_id",       limit: 4
    t.string   "subject_type",     limit: 255
    t.integer  "notify_type",      limit: 4
    t.integer  "status",           limit: 4
    t.string   "path",             limit: 255
    t.text     "body_html",        limit: 65535
    t.integer  "category",         limit: 4
    t.text     "extras",           limit: 65535
    t.integer  "receive_platform", limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "remark",     limit: 255
    t.string   "pinyin",     limit: 255
    t.datetime "deleted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["pinyin"], name: "index_tags_on_pinyin", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255
    t.string   "phone",                limit: 255
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
