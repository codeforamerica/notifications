require 'csv'

class MessageBatchImportService
  MessageTemplateNotFound = Class.new(StandardError)
  ProgramNotFound = Class.new(StandardError)
  MissingHeaders = Class.new(StandardError)
  InvalidPhoneNumberException = Class.new(StandardError)

  REQUIRED_HEADERS = [:case_id, :phone_number, :preferred_language]

  def import_message_batch(template_name, program_name, recipient_csv)
    message_template = MessageTemplate.find_by(name: template_name)
    raise MessageTemplateNotFound unless message_template

    program = Program.find_by(name: program_name)
    raise ProgramNotFound unless program

    recipients_file = local_or_download(recipient_csv)

    message_batch = MessageBatch.create(message_template: message_template, program: program)

    row_count = 0
    CSV.foreach(recipients_file, headers: true, header_converters: :symbol, strip: true) do |row|
      raise MissingHeaders if REQUIRED_HEADERS.difference(row.headers).any?
      row_count += 1
      params = extract_params(row)
      begin
        Recipient.create!(program_case_id: row[:case_id], phone_number: row[:phone_number], message_batch: message_batch, preferred_language: row[:preferred_language], params: params)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Row #{row_count} failed: #{e.message}"
      end
    end

    message_batch
  end

  private

  def extract_params(row)
    row.to_h.except(*REQUIRED_HEADERS)
  end

  def local_or_download(recipient_csv)
    uri = URI(recipient_csv)
    if uri.scheme == 's3'
        s3 = Aws::S3::Client.new
        file = Tempfile.new
        s3.get_object({ bucket: uri.host, key: uri.path[1..]}, target: file)
        file.path
    else
      recipient_csv
    end
  end
end
