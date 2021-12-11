# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_806_140_224) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pgcrypto'
  enable_extension 'plpgsql'

  create_table 'comments', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.uuid 'user_id'
    t.text 'message'
    t.uuid 'commentable_id', default: -> { 'gen_random_uuid()' }
    t.string 'commentable_type'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[commentable_type commentable_id], name: 'index_comments_on_commentable_type_and_commentable_id'
  end

  create_table 'issues', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name'
    t.string 'note'
    t.integer 'priority', default: 1
    t.uuid 'project_id'
    t.uuid 'user_id'
    t.boolean 'draft', default: true
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'projects', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'name'
    t.text 'note'
    t.integer 'priority', default: 1
    t.uuid 'user_id'
    t.boolean 'active', default: true
    t.boolean 'draft', default: true
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'uploads', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'filename'
    t.string 'ext'
    t.uuid 'uploadable_id', default: -> { 'gen_random_uuid()' }
    t.string 'uploadable_type'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index %w[uploadable_type uploadable_id], name: 'index_uploads_on_uploadable_type_and_uploadable_id'
  end

  create_table 'users', id: :uuid, default: -> { 'gen_random_uuid()' }, force: :cascade do |t|
    t.string 'username'
    t.string 'email'
    t.string 'password_digest'
    t.string 'auth_token'
    t.string 'about'
    t.integer 'role', default: 4
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
