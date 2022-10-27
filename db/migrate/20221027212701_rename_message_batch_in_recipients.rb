class RenameMessageBatchInRecipients < ActiveRecord::Migration[7.0]
  def change
    rename_column(:recipients, :message_batches_id, :message_batch_id)
  end
end
