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
    is_keyword = process_keyword(sms_message)
    unless is_keyword
      recipient = Recipient.create(phone_number: sms_message.from)
      MessageService.new.send_message(recipient, I18n.t(:autoresponse))
    end

    head :created
  end

  private

  TWILIO_KEYWORDS = %w(STOP START UNSTOP HELP)
  def process_keyword(sms_message)
    message_is_keyword = false
    Program.all.each do |program|
      response = nil
      if keyword?(sms_message.body, program.opt_in_keywords)
        message_is_keyword = true
        opt_in_language = keyword_language(sms_message.body, program.opt_in_keywords).first
        response = Mobility.with_locale(opt_in_language) { program.opt_in_response }
        ConsentChange.create(new_consent: true, change_source: "sms", sms_message: sms_message, program: program)
      elsif keyword?(sms_message.body, program.opt_out_keywords)
        message_is_keyword = true
        opt_out_language = keyword_language(sms_message.body, program.opt_out_keywords).first
        response = Mobility.with_locale(opt_out_language) { program.opt_out_response }
        ConsentChange.create(new_consent: false, change_source: "sms", sms_message: sms_message, program: program)
      elsif keyword?(sms_message.body, program.help_keywords)
        message_is_keyword = true
        help_language = keyword_language(sms_message.body, program.help_keywords).first
        response = Mobility.with_locale(help_language) { program.help_response }
      end
      twilio_responded = TWILIO_KEYWORDS.any?{ |s| s.casecmp(sms_message.body)==0 }
      if response.present? and !twilio_responded
        recipient = Recipient.create(phone_number: sms_message.from)
        MessageService.new.send_message(recipient, response)
      end
    end
    message_is_keyword
  end

  def keyword?(text, keywords_by_language)
    keywords_by_language.any? do |language, keywords|
      keywords_by_language[language].any? do |keyword|
        keyword.casecmp?(text)
      end
    end
  end

  def keyword_language(text, keywords_by_language)
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
