module TwilioHelper
  def twilio_client
    Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
  end

  def twilio_number
    Rails.configuration.twilio.phone_number
  end

  def twilio_auth_token
    Rails.application.credentials.twilio.auth_token
  end

  def twilio_account_sid
    Rails.configuration.twilio.account_sid
  end
end
