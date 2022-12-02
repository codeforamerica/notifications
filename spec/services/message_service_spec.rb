require 'rails_helper'

describe MessageService do

  describe "#send_message" do
    let(:twilio_client_double) { double }
    let(:twilio_messages_double) { double }
    let(:twilio_message_double) { instance_double(Twilio::REST::Api::V2010::AccountContext::MessageInstance).as_null_object }
    let(:twilio_rest_error_double) { Twilio::REST::RestError.new(double.as_null_object, double.as_null_object) }

    before do
      allow_any_instance_of(TwilioHelper).to receive(:twilio_client).and_return(twilio_client_double)
      allow(twilio_client_double).to receive(:messages).and_return(twilio_messages_double)

      allow(twilio_message_double).to receive(:direction).and_return(:outbound_api)
      allow(twilio_message_double).to receive(:status).and_return(:queued)
    end

    context "when a message fails due to a consent check failure" do
      it "sets the recipient sms_status field appropriately" do
        allow(twilio_messages_double).to receive(:create).and_raise(twilio_rest_error_double)
        allow_any_instance_of(Twilio::REST::RestError).to receive(:code).and_return("123")
        allow_any_instance_of(Twilio::REST::RestError).to receive(:error_message).and_return("api error")

        recipient = create(:recipient)
        program = create(:program)
        create_consent_change(false, recipient, program, DateTime.now - 1)
        expect { described_class.new.send_message(recipient, "test", nil) }
          .to change(recipient, :sms_status).from("imported").to("consent_check_failed")
      end
    end

    context "when a message fails due to an API error" do
      it "sets the recipient sms_status and sms_api_error_* fields appropriately" do
        allow(twilio_messages_double).to receive(:create).and_raise(twilio_rest_error_double)
        allow_any_instance_of(Twilio::REST::RestError).to receive(:code).and_return("123")
        allow_any_instance_of(Twilio::REST::RestError).to receive(:error_message).and_return("api error")

        recipient = create(:recipient)
        expect { described_class.new.send_message(recipient, "test", nil) }
          .to change(recipient, :sms_status).from("imported").to("api_error")
          .and change(recipient, :sms_api_error_code).from(nil).to("123")
          .and change(recipient, :sms_api_error_message).from(nil).to("api error")
      end
    end

    context "when a message is successfully sent" do
      it "sets the recipient sms_status field appropriately" do
        allow(twilio_messages_double).to receive(:create).and_return(twilio_message_double)

        recipient = create(:recipient)
        expect { described_class.new.send_message(recipient, "test", nil) }
          .to change(recipient, :sms_status).from("imported").to("api_success")
      end
    end
  end
end
