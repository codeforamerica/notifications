class MakeSmsMessagePhoneNumbersNotNull < ActiveRecord::Migration[7.0]
  def change

    change_column_null :sms_messages, :from, false
    change_column_null :sms_messages, :to, false

  end
end
