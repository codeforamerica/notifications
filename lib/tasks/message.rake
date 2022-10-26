# Invoke like:
# rake "message:send_test_message[+15555555555, This is your message body]"
# (For now, message body can not contain commas)
namespace :message do
  desc "sends a test message"
  task :send_test_message, [:to_number, :message_body] => :environment do |task, args|
    MessageService.new.send_message(args[:to_number], args[:message_body])
  end
end
