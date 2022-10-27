class MessageService
  include TwilioHelper

  def send_message(to, body)
    message = twilio_client.messages.create(
      from: twilio_number,
      status_callback: "#{ENV['NGROK_URL']}/sms/status_callback",
      to: to,
      body: body
    )
    Rails.logger.info "Sent message #{message.sid} status: #{message.status}"
  end
end
