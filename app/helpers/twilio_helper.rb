module TwilioHelper
  def twilio_client
    Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
  end

  def twilio_messaging_service_sid
    Rails.configuration.twilio.messaging_service_sid
  end

  def twilio_auth_token
    Rails.application.credentials.twilio.auth_token
  end

  def twilio_account_sid
    Rails.configuration.twilio.account_sid
  end
end
