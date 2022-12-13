require 'rails_helper'

describe MessageBatchImportService do

  let(:program) { create(:program) }
  let(:notify_message_template) { create(:message_template, name: 'NotifyMessage', body: 'Notify message body') }

  describe "#import_message_batch" do
    context "when the message_template cannot be found" do
      specify { expect { described_class.new.import_message_batch('non_existent_message_template', program.name, 'some_recipients.csv') }.to raise_error(MessageBatchImportService::MessageTemplateNotFound) }
    end

    context "when the program cannot be found" do
      specify { expect { described_class.new.import_message_batch(notify_message_template.name, 'NO PROGRAM', 'some_recipients.csv') }.to raise_error(MessageBatchImportService::ProgramNotFound) }
    end

    context "when the recipients CSV is not a valid file" do
      specify { expect { described_class.new.import_message_batch(notify_message_template.name, program.name, 'some_recipients.csv') }.to raise_error(SystemCallError) }
    end

    context "when the CSV has incorrect headers" do
      specify { expect { described_class.new.import_message_batch(notify_message_template.name, program.name, file_fixture('recipients_bad_headers.csv')) }.to raise_error(MessageBatchImportService::MissingHeaders) }
    end

    context "when on the happy path" do
      it "creates a MessageBatch" do
        expect { described_class.new.import_message_batch(notify_message_template.name, program.name, file_fixture('good_recipients.csv')) }
          .to change(MessageBatch, :count).from(0).to(1)
          .and change(Recipient, :count).from(0).to(2)
      end
      it "creates the recipients" do
        message_batch = described_class.new.import_message_batch(notify_message_template.name, program.name, file_fixture('good_recipients.csv'))
        expect(message_batch.recipients.pluck(:program_case_id, :phone_number)).to contain_exactly(['ABCD', '4155551212'], ['567F', '8005551212'])
      end
    end

    context "when there are extra fields in the CSV" do
      it "creates the recipients" do
        message_batch = described_class.new.import_message_batch(notify_message_template.name, program.name, file_fixture('recipients_with_params.csv'))
        expect(message_batch.recipients.pluck(:params)).to contain_exactly({preferred_name: 'Luke', renewal_date: '2023-01-20'}.stringify_keys, {preferred_name: 'Hans', renewal_date: '2023-01-20'}.stringify_keys)
      end
    end
  end
end
