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

ActiveRecord::Schema.define(:version => 20120306152406) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "index"
    t.string   "create"
    t.string   "destroy"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "children", :force => true do |t|
    t.string   "first_name",                 :null => false
    t.string   "second_name"
    t.string   "last_name"
    t.datetime "birth_date",                 :null => false
    t.integer  "family_id",                  :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "profile_image_file_size"
    t.string   "profile_image_file_name"
    t.datetime "profile_image_updated_at"
    t.string   "profile_image_content_type"
    t.string   "profile_image_remote_url"
  end

  create_table "families", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.string   "zip_code",   :limit => 10
  end

  create_table "relations", :force => true do |t|
    t.integer "user_id"
    t.integer "family_id"
    t.string  "member_type"
    t.string  "display_name"
    t.string  "token"
    t.boolean "accepted",     :default => false
  end

  create_table "services", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
    t.string   "secret"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.date     "update_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["update_at"], :name => "index_user_sessions_on_update_at"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.date     "current_login_at"
    t.boolean  "email_confirmed",     :default => false
    t.integer  "avatar_file_size"
    t.string   "avatar_file_name"
    t.datetime "avatar_updated_at"
    t.string   "avatar_content_type"
    t.string   "flickr_id"
  end

end
