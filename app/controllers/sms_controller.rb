class SmsController < ApiController
  include TwilioHelper
  before_action :ensure_twilio_request

  def status_callback
    sms_message = SmsMessage.find_by(message_sid: params["MessageSid"])
    if sms_message
      sms_message.update(
        status: params["MessageStatus"],
        error_code: params["ErrorCode"]
      )
      head :ok
    else
      head :not_found
    end
  end

  def incoming_message
    SmsMessage.create(
      message_sid: params["MessageSid"],
      from: params["From"],
      to: params["To"],
      body: params["Body"],
      direction: :inbound,
      status: params["SmsStatus"].downcase
    )
    head :created
  end

  private

  def ensure_twilio_request
    validator = Twilio::Security::RequestValidator.new(twilio_auth_token)
    twilio_signature = request.headers['X-Twilio-Signature'] || ''
    twilio_request = validator.validate(request.url, request.POST, twilio_signature)
    head :forbidden unless twilio_request
  end
end
