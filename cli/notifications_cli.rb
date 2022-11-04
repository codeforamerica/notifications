require File.expand_path('../config/environment', __dir__)

class NotificationsCli < Thor
  desc "import_message_batch message_template_name recipients_csv", "Import a new message batch to send message named message_template_name to recipients_csv "
  def import_message_batch(message_template_name, recipients_csv)
    MessageBatchImportService.new.import_message_batch(message_template_name, recipients_csv)
  rescue MessageBatchImportService::MessageTemplateNotFound
    puts "Missing Message Template: Cannot find template named #{message_template_name}"
  rescue MessageBatchImportService::MissingHeaders
    puts "Missing Headers: Required headers were not found in #{recipients_csv}"
  rescue Exception => e
    puts e.message
  end

  desc "send_test_message to_number message_body", "Sends a single SMS containing message_body to to_number. e.g. bin/cli send_test_message +15555555555 'Hello, this is phone'"
  def send_test_message(to_number, message_body)
    message_template = MessageTemplate.create!(
      name: "Test Message (#{DateTime.now})",
      body: message_body
    )
    message_batch = MessageBatch.create!(
      message_template: message_template
    )
    recipient = Recipient.create!(
      program: "SNAP",
      program_case_id: "0",
      message_batch: message_batch,
      phone_number: to_number
    )

    MessageService.new.send_message(recipient, message_template.body)

  end
end
