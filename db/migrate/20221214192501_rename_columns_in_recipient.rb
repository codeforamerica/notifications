class RenameColumnsInRecipient < ActiveRecord::Migration[7.0]
  def change
    rename_column(:recipients, :sms_api_error_code, :sms_error_code)
    rename_column(:recipients, :sms_api_error_message, :sms_error_message)
  end
end
