require File.expand_path('../config/environment', __dir__)

class NotificationsCli < Thor
  desc "import_message_batch message_template_name recipients_csv", "import a new message batch"
  def import_message_batch(message_template_name, recipients_csv)
    MessageBatchImportService.new.import_message_batch(message_template_name, recipients_csv)
  rescue MessageBatchImportService::MessageTemplateNotFound
    puts "Missing Message Template: Cannot find template named #{message_template_name}"
  rescue MessageBatchImportService::MissingHeaders
    puts "Missing Headers: Required headers were not found in #{recipients_csv}"
  rescue Exception => e
    puts e.message
  end

  desc "send_test_message to_number message_body", "Sends a single SMS containing message_body to to_number. e.g. thor message:send_test_message +15555555555 'Hello, this is phone'"
  def send_test_message(to_number, message_body)
    MessageService.new.send_message(to_number, message_body)
  end
end
