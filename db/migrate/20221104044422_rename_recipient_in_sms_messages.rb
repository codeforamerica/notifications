class RenameRecipientInSmsMessages < ActiveRecord::Migration[7.0]
  def change
    rename_column(:sms_messages, :recipients_id, :recipient_id)
  end
end
