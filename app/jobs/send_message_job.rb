class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(recipient_id)
    recipient = Recipient.find(recipient_id)

    if recipient.sms_status != "imported"
      Rails.logger.warn "Message already attempted for Recipient #{recipient_id}. Status was #{recipient.sms_status}"
      return
    end

    MessageService.new.send_message(recipient, recipient.message_batch.message_template.body)
  end
end
