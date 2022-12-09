class AddConsentCheckFailedToRecipientStatusEnum < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TYPE recipient_status ADD VALUE IF NOT EXISTS 'consent_check_failed' AFTER 'imported';
    SQL
  end

  def down
    # Enum values can't be dropped. You can read why here:
    # https://www.postgresql.org/message-id/29F36C7C98AB09499B1A209D48EAA615B7653DBC8A@mail2a.alliedtesting.com
  end
end
