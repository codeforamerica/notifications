class AddStatusToRecipient < ActiveRecord::Migration[7.0]

  def up
    create_enum :recipient_status, %w(imported api_error api_success delivery_error delivery_success)

    change_table :recipients do |t|
      t.enum :sms_status, enum_type: :recipient_status, default: "imported", null: false
      t.string :sms_api_error_code
      t.string :sms_api_error_message
    end
  end

  def down
    remove_column :recipients, :sms_status
    remove_column :recipients, :sms_api_error_code
    remove_column :recipients, :sms_api_error_message

    execute <<-SQL
    DROP TYPE recipient_status;
    SQL
  end
end
