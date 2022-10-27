class SmsController < ApiController
  include TwilioHelper
  before_action :ensure_twilio_request

  def status_callback
    sms_message = SmsMessage.find_by(message_sid: params["MessageSid"])
    if sms_message
      status = params["MessageStatus"]
      sms_message.update(
        status: status,
        error_code: params["ErrorCode"]
      )
      recipient = sms_message.recipient
      if recipient
        if %w(sent delivered).contains? status
          recipient.update(status: :delivery_success)
        elsif %w(delivery_unknown undelivered failed).contains? status
          recipient.update(status: :delivery_error)
        end
      end
      head :ok
    else
      head :not_found
    end
  end

  def incoming_message
    sms_message = SmsMessage.create(
      message_sid: params["MessageSid"],
      from: params["From"],
      to: params["To"],
      body: params["Body"],
      direction: :inbound,
      status: params["SmsStatus"].downcase
    )

    if opt_in? sms_message.body
      ConsentChange.create(new_consent: true, change_source: :sms, sms_message: sms_message)
    elsif opt_out? sms_message.body
      ConsentChange.create(new_consent: false, change_source: :sms, sms_message: sms_message)
    end

    head :created
  end

  private

  def ensure_twilio_request
    validator = Twilio::Security::RequestValidator.new(twilio_auth_token)
    twilio_signature = request.headers['X-Twilio-Signature'] || ''
    twilio_request = validator.validate(request.url, request.POST, twilio_signature)
    head :forbidden unless twilio_request
  end

  def consent_change?(message_body)
    opt_out?(message_body) or opt_in?(message_body)
  end

  def opt_out?(message_body)
    english_opt_out_keywords = %w(STOP STOPALL UNSUBSCRIBE CANCEL END QUIT)
    spanish_opt_out_keywords = %w(DETENER FIN CANCELAR SUSCRIBIRSE DEJAR ALTO)
    english_opt_out_keywords.include? message_body or spanish_opt_out_keywords.include? message_body
  end

  def opt_in?(message_body)
    %w(START YES UNSTOP).include? message_body
  end

end
