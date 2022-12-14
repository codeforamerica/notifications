class AddNewValuetoRecipientSmsStatus < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    execute <<-SQL
    ALTER TYPE recipient_status ADD VALUE IF NOT EXISTS 'data_error' AFTER 'delivery_success';
    SQL
  end
end
