require 'csv'

class MessageBatchImportService
  MessageTemplateNotFound = Class.new(StandardError)
  MissingHeaders = Class.new(StandardError)
  InvalidPhoneNumberException = Class.new(StandardError)

  REQUIRED_HEADERS = [:case_id, :phone_number, :preferred_language]

  def import_message_batch(message_template_name, recipient_csv)
    message_template = MessageTemplate.find_by(name: message_template_name)
    raise MessageTemplateNotFound unless message_template

    message_batch = MessageBatch.create(message_template: message_template)

    created_count = 0
    CSV.foreach(recipient_csv, headers: true, header_converters: :symbol) do |row|
      raise MissingHeaders if REQUIRED_HEADERS.difference(row.headers).any?
      phone_number = convert_phone_number(row[:phone_number])
      Recipient.create(program: 'SNAP', program_case_id: row[:case_id], phone_number: phone_number, message_batch: message_batch, preferred_language: row[:preferred_language].strip)
      created_count += 1
    end
  end

  private

  def convert_phone_number(phone_number)
    phone_number = phone_number.strip
    if phone_number =~ /\A\+1\d{10}\z/
      phone_number
    elsif phone_number =~ /\A1\d{10}\z/
      '+' + phone_number
    elsif phone_number =~ /\A\d{10}\z/
      '+1' + phone_number
    else
      raise InvalidPhoneNumberException
    end
  end
end
