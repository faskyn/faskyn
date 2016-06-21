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

ActiveRecord::Schema.define(version: 20160621122534) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "comment_replies", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "comment_id", null: false
    t.string   "body",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comment_replies", ["comment_id"], name: "index_comment_replies_on_comment_id", using: :btree
  add_index "comment_replies", ["user_id"], name: "index_comment_replies_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "commentable_id",   null: false
    t.string   "commentable_type", null: false
    t.string   "body",             null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "email",      null: false
    t.text     "comment",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "sender_id",    null: false
    t.integer  "recipient_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "conversations", ["recipient_id"], name: "index_conversations_on_recipient_id", using: :btree
  add_index "conversations", ["sender_id"], name: "index_conversations_on_sender_id", using: :btree

  create_table "group_invitations", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.integer  "group_invitable_id"
    t.string   "group_invitable_type"
    t.boolean  "accepted",             default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "industries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "industry_products", force: :cascade do |t|
    t.integer "product_id",  null: false
    t.integer "industry_id", null: false
  end

  add_index "industry_products", ["industry_id"], name: "index_industry_products_on_industry_id", using: :btree
  add_index "industry_products", ["product_id"], name: "index_industry_products_on_product_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "body"
    t.integer  "conversation_id",                 null: false
    t.integer  "user_id",                         null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "message_attachment"
    t.string   "message_attachment_id"
    t.string   "message_attachment_filename"
    t.integer  "message_attachment_size"
    t.string   "message_attachment_content_type"
    t.text     "link"
  end

  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "recipient_id",    null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "sender_id",       null: false
    t.datetime "checked_at"
    t.integer  "notifiable_id",   null: false
    t.string   "notifiable_type", null: false
    t.string   "action",          null: false
  end

  add_index "notifications", ["recipient_id"], name: "index_notifications_on_recipient_id", using: :btree
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.text     "body",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "post_image"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "product_customer_users", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.integer  "product_customer_id", null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "product_customer_users", ["product_customer_id"], name: "index_product_customer_users_on_product_customer_id", using: :btree
  add_index "product_customer_users", ["user_id"], name: "index_product_customer_users_on_user_id", using: :btree

  create_table "product_customers", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.string   "customer",   null: false
    t.text     "usage",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "website",    null: false
  end

  add_index "product_customers", ["product_id"], name: "index_product_customers_on_product_id", using: :btree

  create_table "product_leads", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.string   "lead",       null: false
    t.text     "pitch",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "website"
  end

  add_index "product_leads", ["product_id"], name: "index_product_leads_on_product_id", using: :btree

  create_table "product_users", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "product_id", null: false
    t.string   "role",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "product_users", ["product_id"], name: "index_product_users_on_product_id", using: :btree
  add_index "product_users", ["role"], name: "index_product_users_on_role", using: :btree
  add_index "product_users", ["user_id"], name: "index_product_users_on_user_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.string   "website",       null: false
    t.string   "oneliner",      null: false
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name",          null: false
    t.string   "product_image"
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",      null: false
    t.string   "first_name",   null: false
    t.string   "last_name",    null: false
    t.string   "company",      null: false
    t.string   "job_title",    null: false
    t.string   "phone_number"
    t.text     "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "avatar"
    t.string   "location"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", unique: true, using: :btree

  create_table "reviews", force: :cascade do |t|
    t.integer  "user_id",             null: false
    t.integer  "product_customer_id", null: false
    t.text     "body",                null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "reviews", ["product_customer_id"], name: "index_reviews_on_product_customer_id", using: :btree
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id", using: :btree

  create_table "socials", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "page_url"
    t.string   "picture_url"
    t.string   "location"
    t.string   "description"
    t.string   "phone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "profile_id"
    t.string   "email"
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.string   "nickname"
  end

  add_index "socials", ["profile_id"], name: "index_socials_on_profile_id", using: :btree

  create_table "tasknamecompanies", force: :cascade do |t|
    t.string   "term"
    t.integer  "popularity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "assigner_id",  null: false
    t.integer  "executor_id",  null: false
    t.string   "name"
    t.text     "content",      null: false
    t.datetime "deadline"
    t.datetime "completed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "tasks", ["assigner_id"], name: "index_tasks_on_assigner_id", using: :btree
  add_index "tasks", ["executor_id"], name: "index_tasks_on_executor_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "new_chat_notification",  default: 0
    t.integer  "new_other_notification", default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "comment_replies", "comments"
  add_foreign_key "comment_replies", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "conversations", "users", column: "recipient_id"
  add_foreign_key "conversations", "users", column: "sender_id"
  add_foreign_key "industry_products", "industries"
  add_foreign_key "industry_products", "products"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users", column: "recipient_id"
  add_foreign_key "notifications", "users", column: "sender_id"
  add_foreign_key "posts", "users"
  add_foreign_key "product_customer_users", "product_customers"
  add_foreign_key "product_customer_users", "users"
  add_foreign_key "product_customers", "products"
  add_foreign_key "product_leads", "products"
  add_foreign_key "product_users", "products"
  add_foreign_key "product_users", "users"
  add_foreign_key "products", "users"
  add_foreign_key "profiles", "users"
  add_foreign_key "reviews", "product_customers"
  add_foreign_key "reviews", "users"
  add_foreign_key "tasks", "users", column: "assigner_id"
  add_foreign_key "tasks", "users", column: "executor_id"
end
