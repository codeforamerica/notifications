class ConsentService

  def process_consent_change(sms_message)
    return unless sms_message.direction == "inbound"
    Program.all.each do |program|
      opt_in_languages = consent_change_keyword?(sms_message.body, program.opt_in_keywords)
      opt_out_languages = consent_change_keyword?(sms_message.body, program.opt_out_keywords)
      if !opt_in_languages.empty?
        response = Mobility.with_locale(opt_in_languages.first) { program.opt_in_response }
        record_and_respond_to_consent_change_via_sms(true, response, program, sms_message)
      elsif !opt_out_languages.empty?
        response = Mobility.with_locale(opt_out_languages.first) { program.opt_out_response }
        record_and_respond_to_consent_change_via_sms(false, response, program, sms_message)
      end
    end
  end

  def check_consent(recipient, program)
    default_consent = true
    latest_consent_change = ConsentChange.latest_for(recipient.phone_number, program)
    if latest_consent_change.present?
      latest_consent_change.new_consent
    else
      default_consent
    end
  end

  private

  def record_and_respond_to_consent_change_via_sms(new_consent, response, program, sms_message)
    ConsentChange.create(new_consent: new_consent, change_source: "sms", sms_message: sms_message, program: program)
    recipient = Recipient.create(phone_number: sms_message.from)
    MessageService.new.send_message(recipient, response, nil)
  end

  def consent_change_keyword?(text, keywords_by_language)
    keywords_by_language.keys.select do |language|
      keywords_by_language[language].any? do |keyword|
        keyword.casecmp?(text)
      end
    end
  end

end
