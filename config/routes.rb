Rails.application.routes.draw do
  post 'sms/incoming_message'
  post 'sms/status_callback'
end
