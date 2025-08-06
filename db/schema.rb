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

ActiveRecord::Schema[7.0].define(version: 2025_08_06_033230) do
  create_table "daily_reports", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "receiver_id"
    t.integer "status", default: 0
    t.datetime "reviewed_at", precision: nil
    t.text "planned_tasks"
    t.text "actual_tasks"
    t.text "incomplete_reason"
    t.text "next_day_planned_tasks"
    t.text "manager_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "report_date"
    t.index ["created_at"], name: "index_daily_reports_on_created_at"
    t.index ["owner_id"], name: "index_daily_reports_on_owner_id"
    t.index ["receiver_id"], name: "index_daily_reports_on_receiver_id"
    t.index ["status"], name: "index_daily_reports_on_status"
  end

  create_table "departments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "manager_id"
    t.index ["manager_id"], name: "index_departments_on_manager_id"
    t.index ["name"], name: "index_departments_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.integer "role"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "daily_reports", "users", column: "owner_id"
  add_foreign_key "daily_reports", "users", column: "receiver_id"
  add_foreign_key "departments", "users", column: "manager_id"
  add_foreign_key "users", "departments"
end
