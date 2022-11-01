class AddConstraintsToRecipients < ActiveRecord::Migration[7.0]
  def change
    change_column_null :recipients, :program, false
    change_column_null :recipients, :program_case_id, false
    change_column_null :recipients, :phone_number, false
  end
end
