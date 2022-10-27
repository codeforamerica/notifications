class AddSmsMessageEnums < ActiveRecord::Migration[7.0]
  def up
    create_enum :sms_message_direction, ["inbound", "outbound-api", "outbound-call", "outbound-reply"]
    create_enum :sms_message_status, %w(accepted scheduled canceled queued sending sent failed delivered undelivered receiving received read)

    change_table :sms_messages do |t|
      t.enum :direction, enum_type: :sms_message_direction, null: false
      t.enum :status, enum_type: :sms_message_status, null: false
    end
  end

  def down
    remove_column :sms_messages, :direction
    remove_column :sms_messages, :status

    execute <<-SQL
    DROP TYPE sms_message_direction;
    DROP TYPE sms_message_status;
    SQL
  end
end
