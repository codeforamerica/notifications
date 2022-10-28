require 'rails_helper'

describe MessageBatchImportService do

  let(:message_template) { MessageTemplate.create(name: 'NotifyMessage', body: 'Notify message body') }

  describe "#import_message_batch" do
    context "when the message_template cannot be found" do
      specify { expect { described_class.new.import_message_batch('non_existent_message_template', 'some_recipients.csv') }.to raise_error(MessageBatchImportService::MessageTemplateNotFound) }
    end

    context "when the recipients CSV is not a valid file" do
      specify { expect { described_class.new.import_message_batch(message_template.name, 'some_recipients.csv') }.to raise_error(SystemCallError) }
    end

    context "when the CSV has incorrect headers" do
      specify { expect { described_class.new.import_message_batch(message_template.name, file_fixture('recipients_bad_headers.csv')) }.to raise_error(MessageBatchImportService::MissingHeaders) }
    end

    context "when on the happy path" do
      it "creates a MessageBatch" do
        expect { described_class.new.import_message_batch(message_template.name, file_fixture('good_recipients.csv')) }
          .to change(MessageBatch, :count).from(0).to(1)
          .and change(Recipient, :count).from(0).to(2)
      end
    end
  end
end
