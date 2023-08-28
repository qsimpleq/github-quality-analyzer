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

ActiveRecord::Schema[7.0].define(version: 2023_08_28_123241) do
  create_table "repositories", force: :cascade do |t|
    t.integer "github_id"
    t.string "name"
    t.string "language"
    t.datetime "repo_created_at"
    t.datetime "repo_updated_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.index ["github_id"], name: "index_repositories_on_github_id"
    t.index ["language"], name: "index_repositories_on_language"
    t.index ["name"], name: "index_repositories_on_name"
    t.index ["user_id"], name: "index_repositories_on_user_id"
  end

  create_table "repository_checks", force: :cascade do |t|
    t.integer "repository_id", null: false
    t.boolean "check_passed", default: false
    t.string "aasm_state", default: "created", null: false
    t.string "commit_id"
    t.integer "offense_count"
    t.json "check_result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["aasm_state"], name: "index_repository_checks_on_aasm_state"
    t.index ["repository_id"], name: "index_repository_checks_on_repository_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "nickname"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "repository_checks", "repositories"
end
