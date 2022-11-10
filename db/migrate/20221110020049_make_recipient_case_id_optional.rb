class MakeRecipientCaseIdOptional < ActiveRecord::Migration[7.0]
  def change

    change_column_null :recipients, :message_batch_id, true
    change_column_null :recipients, :program_case_id, true

  end
end
