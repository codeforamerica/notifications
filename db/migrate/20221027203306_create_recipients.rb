class CreateRecipients < ActiveRecord::Migration[7.0]
  def change
    create_table :recipients do |t|
      t.string :program
      t.string :program_case_id
      t.string :phone_number
      t.references :message_batches, null: false, foreign_key: true

      t.timestamps
    end
  end
end
