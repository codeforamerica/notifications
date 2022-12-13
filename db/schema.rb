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

ActiveRecord::Schema[7.0].define(version: 2022_12_13_143751) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "locale", ["en", "es"]
  create_enum "recipient_status", ["imported", "consent_check_failed", "api_error", "api_success", "delivery_error", "delivery_success"]
  create_enum "sms_message_direction", ["inbound", "outbound-api", "outbound-call", "outbound-reply"]
  create_enum "sms_message_status", ["accepted", "scheduled", "canceled", "queued", "sending", "sent", "failed", "delivered", "undelivered", "receiving", "received", "read"]

  create_table "consent_changes", force: :cascade do |t|
    t.boolean "new_consent"
    t.string "change_source", null: false
    t.bigint "sms_message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "program_id"
    t.index ["program_id"], name: "index_consent_changes_on_program_id"
    t.index ["sms_message_id"], name: "index_consent_changes_on_sms_message_id"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "message_batches", force: :cascade do |t|
    t.bigint "message_template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "program_id"
    t.index ["message_template_id"], name: "index_message_batches_on_message_template_id"
    t.index ["program_id"], name: "index_message_batches_on_program_id"
  end

  create_table "message_templates", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "body", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_message_templates_on_name", unique: true
  end

  create_table "programs", force: :cascade do |t|
    t.string "name", null: false
    t.jsonb "opt_in_keywords", null: false
    t.jsonb "opt_out_keywords", null: false
    t.jsonb "opt_in_response", default: {}, null: false
    t.jsonb "opt_out_response", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "help_keywords", null: false
    t.jsonb "help_response", default: {}, null: false
  end

  create_table "recipients", force: :cascade do |t|
    t.string "program_case_id"
    t.string "phone_number", null: false
    t.bigint "message_batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "sms_status", default: "imported", null: false, enum_type: "recipient_status"
    t.string "sms_api_error_code"
    t.string "sms_api_error_message"
    t.enum "preferred_language", enum_type: "locale"
    t.jsonb "params"
    t.index ["message_batch_id"], name: "index_recipients_on_message_batch_id"
  end

  create_table "sms_messages", force: :cascade do |t|
    t.string "message_sid"
    t.string "from"
    t.string "to"
    t.text "body"
    t.datetime "date_created"
    t.datetime "date_updated"
    t.datetime "date_sent"
    t.string "error_code"
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "direction", null: false, enum_type: "sms_message_direction"
    t.enum "status", null: false, enum_type: "sms_message_status"
    t.bigint "recipient_id"
    t.index ["recipient_id"], name: "index_sms_messages_on_recipient_id"
  end

  add_foreign_key "consent_changes", "sms_messages"
  add_foreign_key "message_batches", "message_templates"
  add_foreign_key "recipients", "message_batches"
  add_foreign_key "sms_messages", "recipients"
end
