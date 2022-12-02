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

ActiveRecord::Schema[7.0].define(version: 2022_12_02_010125) do
  # These are extensions that must be enabled in order to support this database
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
