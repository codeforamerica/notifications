class AddRecipientToSmsMessage < ActiveRecord::Migration[7.0]
  def change
    add_reference :sms_messages, :recipients, foreign_key: true
  end
end
