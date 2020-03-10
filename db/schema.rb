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

ActiveRecord::Schema.define(version: 20200310170203) do

  create_table "activities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "source",     default: 0
    t.integer  "count",      default: 0
    t.string   "url"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["source"], name: "index_activities_on_source", using: :btree
  end

  create_table "api_keys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_api_keys_on_user_id", using: :btree
  end

  create_table "app_versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "app_type"
    t.string   "version_name"
    t.string   "version_code"
    t.string   "download_url"
    t.integer  "upgrade"
    t.text     "changelogs",   limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "attachmentable_id"
    t.string   "attachmentable_type"
    t.string   "name"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "deleted_at"
    t.text     "note",                limit: 65535
    t.string   "sub_type"
    t.integer  "attachment_position"
    t.string   "qiniu_persistent_id"
    t.datetime "updated_at",                        null: false
    t.datetime "created_at",                        null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["attachmentable_id", "attachmentable_type"], name: "index_attachments_on_attachmentable_id_and_attachmentable_type", using: :btree
    t.index ["qiniu_persistent_id"], name: "index_attachments_on_qiniu_persistent_id", using: :btree
    t.index ["user_id"], name: "index_attachments_on_user_id", using: :btree
  end

  create_table "authors", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "reprint_user_id"
    t.integer  "books_count",     default: 0
    t.integer  "level",           default: 0
    t.boolean  "is_identity",     default: false
    t.integer  "experience",      default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["reprint_user_id"], name: "index_authors_on_reprint_user_id", using: :btree
    t.index ["user_id"], name: "index_authors_on_user_id", using: :btree
  end

  create_table "book_chapters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "book_id"
    t.integer  "book_volume_id"
    t.string   "title"
    t.text     "content",         limit: 65535
    t.integer  "word_count"
    t.integer  "next_chapter_id"
    t.integer  "prev_chapter_id"
    t.integer  "is_free"
    t.integer  "types"
    t.decimal  "price",                         precision: 10
    t.float    "discount",        limit: 24
    t.datetime "deleted_at"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "download_url"
    t.index ["book_id"], name: "index_book_chapters_on_book_id", using: :btree
    t.index ["book_volume_id"], name: "index_book_chapters_on_book_volume_id", using: :btree
  end

  create_table "book_marks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.integer  "book_chapter_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["book_chapter_id"], name: "index_book_marks_on_book_chapter_id", using: :btree
    t.index ["book_id"], name: "index_book_marks_on_book_id", using: :btree
    t.index ["user_id"], name: "index_book_marks_on_user_id", using: :btree
  end

  create_table "book_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "book_id"
    t.integer  "user_id"
    t.integer  "relation_type", default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["book_id"], name: "index_book_relations_on_book_id", using: :btree
    t.index ["user_id"], name: "index_book_relations_on_user_id", using: :btree
  end

  create_table "book_tag_relations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "book_id"
    t.integer  "tag_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_tag_relations_on_book_id", using: :btree
    t.index ["tag_id"], name: "index_book_tag_relations_on_tag_id", using: :btree
  end

  create_table "book_volumes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "book_id"
    t.string   "title"
    t.integer  "book_chapters_count",                           default: 0
    t.integer  "is_free"
    t.decimal  "price",                          precision: 10
    t.float    "discount",            limit: 24
    t.integer  "next_volume_id"
    t.integer  "prev_volume_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["book_id"], name: "index_book_volumes_on_book_id", using: :btree
  end

  create_table "books", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.string   "pinyin"
    t.integer  "author_id"
    t.integer  "book_type"
    t.text     "introduction",         limit: 65535
    t.string   "remarks"
    t.integer  "status",                                            default: 0
    t.decimal  "total_price",                        precision: 10
    t.float    "discount",             limit: 24
    t.integer  "words"
    t.integer  "click_count",                                       default: 0
    t.integer  "recommend_count",                                   default: 0
    t.integer  "collection_count",                                  default: 0
    t.integer  "book_volumes_count",                                default: 0
    t.integer  "book_chapters_count",                               default: 0
    t.datetime "deleted_at"
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
    t.integer  "classification_id"
    t.integer  "operator_id"
    t.string   "lastest_download_url"
    t.integer  "lastest_chapter_id"
    t.date     "chapter_updated_date"
    t.string   "source",                                            default: "magicbooks"
    t.index ["author_id"], name: "index_books_on_author_id", using: :btree
    t.index ["book_type"], name: "index_books_on_book_type", using: :btree
  end

  create_table "btear_currencies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.float    "min",              limit: 24
    t.float    "max",              limit: 24
    t.float    "current",          limit: 24
    t.float    "today_first",      limit: 24
    t.date     "today_first_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "top"
  end

  create_table "btear_infos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "currency"
    t.float    "value",      limit: 24
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["currency"], name: "index_btear_infos_on_currency", using: :btree
  end

  create_table "chat_rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "no"
    t.string   "name"
    t.integer  "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chat_rooms_on_book_id", using: :btree
    t.index ["no"], name: "index_chat_rooms_on_no", using: :btree
  end

  create_table "classifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "pinyin"
    t.string   "remark"
    t.integer  "books_count", default: 0
    t.datetime "dalete_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["parent_id"], name: "index_classifications_on_parent_id", using: :btree
    t.index ["pinyin"], name: "index_classifications_on_pinyin", using: :btree
  end

  create_table "eos_knights", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "block_num"
    t.string   "trx_id",      limit: 64
    t.string   "data_md5"
    t.datetime "trx_time"
    t.string   "receiver",    limit: 20
    t.string   "sender",      limit: 20
    t.string   "code"
    t.string   "memo"
    t.string   "symbol"
    t.string   "status"
    t.float    "quantity",    limit: 24
    t.integer  "category"
    t.integer  "category_id"
    t.integer  "sell_id"
    t.string   "buyer"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.float    "current_fee", limit: 24, default: 0.03
    t.index ["block_num"], name: "index_eos_knights_on_block_num", using: :btree
    t.index ["category"], name: "index_eos_knights_on_category", using: :btree
    t.index ["category_id"], name: "index_eos_knights_on_category_id", using: :btree
    t.index ["receiver"], name: "index_eos_knights_on_receiver", using: :btree
    t.index ["sender"], name: "index_eos_knights_on_sender", using: :btree
    t.index ["trx_id"], name: "index_eos_knights_on_trx_id", using: :btree
  end

  create_table "eos_minings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "eos_user_id"
    t.string   "referrer"
    t.string   "transaction_id"
    t.float    "account",        limit: 24
    t.string   "from"
    t.string   "to"
    t.string   "quantity"
    t.text     "memo",           limit: 65535
    t.string   "category",       limit: 50
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["category"], name: "index_eos_minings_on_category", using: :btree
    t.index ["eos_user_id"], name: "index_eos_minings_on_eos_user_id", using: :btree
  end

  create_table "eos_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "eos_user_id"
    t.integer  "types",                  default: 0
    t.float    "quantity",    limit: 24
    t.string   "memo"
    t.string   "code"
    t.string   "symbol"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.index ["eos_user_id"], name: "index_eos_records_on_eos_user_id", using: :btree
  end

  create_table "eos_sanguos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "block_num"
    t.string   "trx_id",      limit: 64
    t.string   "data_md5"
    t.datetime "trx_time"
    t.string   "receiver",    limit: 20
    t.string   "sender",      limit: 20
    t.string   "code"
    t.string   "memo"
    t.string   "symbol"
    t.string   "status"
    t.float    "quantity",    limit: 24
    t.integer  "category"
    t.integer  "category_id"
    t.integer  "sell_id"
    t.string   "buyer"
    t.float    "current_fee", limit: 24, default: 0.03
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["block_num"], name: "index_eos_sanguos_on_block_num", using: :btree
    t.index ["category"], name: "index_eos_sanguos_on_category", using: :btree
    t.index ["category_id"], name: "index_eos_sanguos_on_category_id", using: :btree
    t.index ["receiver"], name: "index_eos_sanguos_on_receiver", using: :btree
    t.index ["sender"], name: "index_eos_sanguos_on_sender", using: :btree
    t.index ["trx_id"], name: "index_eos_sanguos_on_trx_id", using: :btree
  end

  create_table "eos_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "chat_room_id"
    t.text     "content",      limit: 65535
    t.integer  "user_id"
    t.integer  "status",                     default: 0
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["chat_room_id"], name: "index_messages_on_chat_room_id", using: :btree
    t.index ["status"], name: "index_messages_on_status", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "notifications", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "title"
    t.text     "body",             limit: 65535
    t.integer  "user_id"
    t.integer  "subject_id"
    t.string   "subject_type"
    t.integer  "notify_type"
    t.integer  "status"
    t.string   "path"
    t.text     "body_html",        limit: 65535
    t.integer  "category"
    t.text     "extras",           limit: 65535
    t.integer  "receive_platform"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "request_logs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "ip"
    t.integer  "count",           default: 0
    t.string   "country"
    t.string   "address"
    t.integer  "user_id"
    t.integer  "last_chapter_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["ip"], name: "index_request_logs_on_ip", using: :btree
    t.index ["last_chapter_id"], name: "index_request_logs_on_last_chapter_id", using: :btree
    t.index ["user_id"], name: "index_request_logs_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "var",                       null: false
    t.text     "value",       limit: 65535
    t.string   "target_type",               null: false
    t.integer  "target_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true, using: :btree
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id", using: :btree
  end

  create_table "sms_codes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "users_id"
    t.string   "phone"
    t.string   "code"
    t.integer  "sms_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["phone", "sms_type"], name: "index_sms_codes_on_phone_and_sms_type", using: :btree
    t.index ["phone"], name: "index_sms_codes_on_phone", using: :btree
    t.index ["users_id"], name: "index_sms_codes_on_users_id", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "remark"
    t.string   "pinyin"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pinyin"], name: "index_tags_on_pinyin", using: :btree
  end

  create_table "user_devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "uid"
    t.string   "device_token"
    t.string   "client_id"
    t.integer  "platform"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "index_user_devices_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email"
    t.string   "phone",                                                   comment: "手机"
    t.string   "name"
    t.datetime "activated"
    t.boolean  "admin",                default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "authentication_token"
    t.string   "password_digest"
    t.integer  "deleted_at"
    t.string   "provider",             default: "magicbook"
    t.string   "provider_uid"
    t.string   "avatar_url"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["phone"], name: "index_users_on_phone", using: :btree
  end

end
