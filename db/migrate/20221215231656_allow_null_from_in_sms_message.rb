class AllowNullFromInSmsMessage < ActiveRecord::Migration[7.0]
  def change
    change_column_null :sms_messages, :from, true
  end
end
