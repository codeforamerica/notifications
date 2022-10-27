class CreateMessageBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :message_batches do |t|
      t.references :message_template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
