require File.expand_path('../config/environment', __dir__)

class NotificationsCli < Thor
  desc "import_message_batch message_template_name program_name recipients_csv", "Import a new message batch associated with program to send message named message_template_name to recipients_csv "
  def import_message_batch(message_template_name, program_name, recipients_csv)
    message_batch = MessageBatchImportService.new.import_message_batch(message_template_name, program_name, recipients_csv)
    puts "MessageBatch #{message_batch.id} created with #{message_batch.recipients.count} recipients"

  rescue MessageBatchImportService::MessageTemplateNotFound
    puts "Missing Message Template: Cannot find template named #{message_template_name}"
  rescue MessageBatchImportService::MissingHeaders
    puts "Missing Headers: Required headers were not found in #{recipients_csv}"
  rescue Exception => e
    puts e.message
  end

  desc "send_test_message to_number message_body", "Sends a single SMS containing message_body to to_number. e.g. bin/cli send_test_message +15555555555 'Hello, this is phone'"
  def send_test_message(to_number, message_body)
    recipient = Recipient.create!(
      phone_number: to_number
    )

    MessageService.new.send_message(recipient, message_body)
  end

  desc "send_message_batch message_batch_id", "Sends messages to all the recipients in the message batch based on the message template associated with the batch"
  def send_message_batch(message_batch_id)
    puts "Sending message batch #{message_batch_id}"

    message_batch = MessageBatch.find(message_batch_id.to_i)
    message_batch.send_messages
  rescue ActiveRecord::RecordNotFound
    puts "Could not find message batch #{message_batch_id}"
    exit 1
  end
end
