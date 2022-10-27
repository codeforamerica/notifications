class CreateSmsMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :sms_messages do |t|
      t.string :message_sid
      t.string :from
      t.string :to
      t.text :body
      t.datetime :date_created
      t.datetime :date_updated
      t.datetime :date_sent
      t.string :error_code
      t.string :error_message

      t.timestamps
    end
  end
end
