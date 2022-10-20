namespace :message do
  desc "sends a test message"
  task :send_test_message, [:message_body] => :environment do |task, args|
    MessageService.new.send_message('+12672528880', args[:message_body])
  end
end
