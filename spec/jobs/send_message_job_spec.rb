require 'rails_helper'

RSpec.describe SendMessageJob, type: :job do

  let (:message_template) { create(:message_template, english_body: english_body, spanish_body: spanish_body)}
  let (:message_batch) { create(:message_batch, message_template: message_template) }
  let (:recipient) { create(:recipient, message_batch: message_batch, sms_status: sms_status, preferred_language: preferred_language) }
  let (:preferred_language) { :en }
  let (:english_body) { 'hello' }
  let (:spanish_body) { 'ola' }

  describe "when performed" do
    let (:message_service) { instance_double(MessageService) }

    context "when the recipient status is imported" do
      let (:sms_status) { :imported }
      it "sends a message to the recipient" do
        allow(MessageService).to receive(:new) { message_service }
        expect(message_service).to receive(:send_message).with(recipient, anything)
        described_class.perform_now recipient.id
      end

      context "when the recipient's language preference is English" do
        let (:preferred_language) { :en }

        it "sends a message in English" do
          allow(MessageService).to receive(:new) { message_service }
          expect(message_service).to receive(:send_message).with(recipient, 'hello')
          described_class.perform_now recipient.id
        end
      end

      context "when the recipient's language preference is Spanish" do
        let (:preferred_language) { :es }

        it "sends a message in Spanish" do
          allow(MessageService).to receive(:new) { message_service }
          expect(message_service).to receive(:send_message).with(recipient, 'ola')
          described_class.perform_now recipient.id
        end
      end

      context "when the template has placeholders" do
        let (:english_body) { 'hello, %{preferred_name}'}

        context "when the recipient has the corresponding extra params" do
          it "sends a message with the placeholders filled in" do
            recipient.update(params: {preferred_name: 'Hans'})
            allow(MessageService).to receive(:new) { message_service }
            expect(message_service).to receive(:send_message).with(recipient, 'hello, Hans')
            described_class.perform_now recipient.id
          end
        end
        context "when the recipient does not have the corresponding extra params" do
          it "records a 'data_error'" do
            recipient.update(params: { name: 'Hans' })
            allow(MessageService).to receive(:new) { message_service }
            expect { described_class.perform_now recipient.id; recipient.reload }
              .to change(recipient, :sms_status).to("data_error").and change(recipient, :sms_error_message).to("missing interpolation argument :preferred_name in \"hello, %{preferred_name}\" ({:name=>\"Hans\"} given)")
          end
        end
      end

      context "when the recipient status is other than imported" do
        let (:sms_status) { :api_success }
        it "does not send a message" do
          allow(MessageService).to receive(:new) { message_service }
          expect(MessageService).to_not have_received(:new)
          described_class.perform_now recipient.id
        end
      end
    end
  end
end
