class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(recipient_id)
    recipient = Recipient.find(recipient_id)

    if recipient.sms_status != "imported"
      Rails.logger.warn "Message already attempted for Recipient #{recipient_id}. Status was #{recipient.sms_status}"
      return
    end

    message_body = recipient.message_batch.get_localized_message_body(recipient.preferred_language)

    # TODO if message_body is nil
    MessageService.new.send_message(recipient, message_body)
  end
end
