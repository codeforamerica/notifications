class SmsController < ApiController
  include TwilioHelper
  before_action :ensure_twilio_request

  def status_callback
    head :accepted
  end

  def incoming_message
    sender_number = params["From"]
    MessageService.new.send_message(sender_number, "Got your message")
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
