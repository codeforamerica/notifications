class MessageService
  include TwilioHelper

  def send_message(to, body)
    begin
      message = twilio_client.messages.create(
        from: twilio_number,
        status_callback: "#{ENV['NGROK_URL']}/sms/status_callback",
        to: to,
        body: body
      )
    rescue Twilio::REST::RestError => error
      SmsMessage.create(
        to: to,
        body: body,
        error_code: error.code,
        error_message: error.error_message,
        direction: :outbound_api,
        status: :failed
      )
    else
      SmsMessage.create(
        message_sid: message.sid,
        from: message.from,
        to: message.to,
        body: message.body,
        date_created: message.date_created,
        date_updated: message.date_updated,
        date_sent: message.date_sent,
        error_code: message.error_code,
        error_message: message.error_message,
        direction: message.direction,
        status: message.status
      )
    end
  end
end
