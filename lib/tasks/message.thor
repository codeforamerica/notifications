require 'thor'

class Message < Thor
  desc "send_test_message to_number message_body", "Sends a single SMS containing message_body to to_number. e.g. thor message:send_test_message +15555555555 'Hello, this is phone'"
  def send_test_message(to_number, message_body)
    MessageService.new.send_message(to_number, message_body)
  end
end