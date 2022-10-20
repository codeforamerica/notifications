class MessageService
  include TwilioHelper

  def send_message(to, body)
    message = twilio_client.messages.create(
      from: twilio_number,
      status_callback: "https://0675-2601-648-8403-9d00-d0fb-7125-e350-4319.ngrok.io/sms/status_callback",
      to: to,
      body: body
    )
    Rails.logger.info "Sent message #{message.sid} status: #{message.status}"
  end
end
