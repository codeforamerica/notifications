class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(recipient_id)
    recipient = Recipient.find(recipient_id)

    if recipient.sms_status != "imported"
      Rails.logger.warn "Message already attempted for Recipient #{recipient_id}. Status was #{recipient.sms_status}"
      return
    end

    begin
      message_body = build_message_body(recipient)
    rescue I18n::MissingInterpolationArgument => exception
      recipient.update(
        sms_status: :api_error,
        sms_error_message: exception.message
      )
      return
    end

    # TODO if message_body is nil
    MessageService.new.send_message(recipient, message_body)
  end

  def build_message_body(recipient)
    body = recipient.message_batch.get_localized_message_body(recipient.preferred_language)
    params = recipient.params || {}
    I18n.backend.send(:interpolate, :en, body, params.symbolize_keys)
  end
end
