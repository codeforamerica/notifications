class MessageService
  include TwilioHelper

  def send_message(recipient, body)

    consent = ConsentService.new.check_consent(recipient, recipient.program)
    unless consent
      recipient.update(sms_status: :consent_check_failed)
      return
    end

    begin
      message = twilio_client.messages.create(
        messaging_service_sid: twilio_messaging_service_sid,
        status_callback: "#{ENV['BASE_URL']}/sms/status_callback",
        to: recipient.phone_number,
        body: body
      )
    rescue Twilio::REST::RestError => error
      recipient.update(
        sms_status: :api_error,
        sms_api_error_code: error.code,
        sms_api_error_message: error.error_message
      )
    else
      recipient.update(sms_status: :api_success)
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
        status: message.status,
        recipient: recipient
      )
    end
  end
end
