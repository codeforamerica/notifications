module TwilioHelper
  def twilio_client
    Twilio::REST::Client.new(twilio_account_sid, twilio_auth_token)
  end

  def twilio_messaging_service_sid
    ENV['TWILIO_MESSAGING_SERVICE_SID']
  end

  def twilio_auth_token
    ENV['TWILIO_AUTH_TOKEN']
  end

  def twilio_account_sid
    ENV['TWILIO_ACCOUNT_SID']
  end
end
