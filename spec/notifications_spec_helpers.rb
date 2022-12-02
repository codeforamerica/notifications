module NotificationsSpecHelpers
  def create_consent_change(new_consent, recipient, program, datetime)
    sms_message = create(
      :sms_message,
      recipient: recipient,
      from: recipient.phone_number
    )
    create(
      :consent_change,
      new_consent: new_consent,
      sms_message: sms_message,
      program: program,
      created_at: datetime
    )
  end
end