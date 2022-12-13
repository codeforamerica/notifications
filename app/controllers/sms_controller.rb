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
        if %w(sent delivered).include? status
          recipient.update(sms_status: :delivery_success)
        elsif %w(delivery_unknown undelivered failed).include? status
          recipient.update(sms_status: :delivery_error)
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
    process_keyword(sms_message)

    head :created
  end

  private

  TWILIO_KEYWORDS = %w(STOP START UNSTOP HELP)
  def process_keyword(sms_message)
    Program.all.each do |program|
      opt_in_languages = keyword?(sms_message.body, program.opt_in_keywords)
      opt_out_languages = keyword?(sms_message.body, program.opt_out_keywords)
      help_languages = keyword?(sms_message.body, program.help_keywords)
      response = nil
      if !opt_in_languages.empty?
        response = Mobility.with_locale(opt_in_languages.first) { program.opt_in_response }
        ConsentChange.create(new_consent: true, change_source: "sms", sms_message: sms_message, program: program)
      elsif !opt_out_languages.empty?
        response = Mobility.with_locale(opt_out_languages.first) { program.opt_out_response }
        ConsentChange.create(new_consent: false, change_source: "sms", sms_message: sms_message, program: program)
      elsif !help_languages.empty?
        response = Mobility.with_locale(opt_out_languages.first) { program.help_response }
      end
      twilio_responded = TWILIO_KEYWORDS.any?{ |s| s.casecmp(sms_message.body)==0 }
      if response.present? and !twilio_responded
        recipient = Recipient.create(phone_number: sms_message.from)
        MessageService.new.send_message(recipient, response)
      end
    end
  end

  def keyword?(text, keywords_by_language)
    keywords_by_language.keys.select do |language|
      keywords_by_language[language].any? do |keyword|
        keyword.casecmp?(text)
      end
    end
  end
  def ensure_twilio_request
    validator = Twilio::Security::RequestValidator.new(twilio_auth_token)
    twilio_signature = request.headers['X-Twilio-Signature'] || ''
    twilio_request = validator.validate(request.url, request.POST, twilio_signature)
    head :forbidden unless twilio_request
  end
end
