class ConsentService

  def check_consent(recipient, program)
    default_consent = true
    latest_consent_change = ConsentChange.latest(recipient.phone_number, program)
    if latest_consent_change.present?
      latest_consent_change.new_consent
    else
      default_consent
    end
  end

end
