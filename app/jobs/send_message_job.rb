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
        sms_status: :data_error,
        sms_error_message: exception.message
      )
      return
    end

    # TODO if message_body is nil
    MessageService.new.send_message(recipient, message_body)
  end

  private

  def params(recipient)
    params = recipient.params || {}
    change_name_to_title_case(params)
    use_last_4_chars_of_client_id(params)
    params.symbolize_keys
  end

  def build_message_body(recipient)
    body = recipient.message_batch.get_localized_message_body(recipient.preferred_language)
    I18n.backend.send(:interpolate, :en, body, params(recipient))
  end

  def change_name_to_title_case(params)
    if params.key?("first_name")
      name = params["first_name"]
      if name.upcase == name or name.downcase == name
        params["first_name"] = name.capitalize
      end
    end
  end

  def use_last_4_chars_of_client_id(params)
    if params.key?("client_id") && params["client_id"].length > 4
      params["client_id"] = params["client_id"][-4..-1]
    end
  end
end
