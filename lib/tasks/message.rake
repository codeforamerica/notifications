namespace :message do
  desc "sends a test message"
  task send_test_message: :environment do
    MessageService.new.send_message('+12672528880', 'Hello')
  end
end
