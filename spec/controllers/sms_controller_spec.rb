require 'rails_helper'

describe SmsController do

  describe "#incoming_message" do

    before :each do
      allow(controller).to receive(:ensure_twilio_request).and_return(true)
    end

    let!(:snap) { create(:program) }

    let(:params) { {
      MessageSid: 'abc',
      From: '+11234567890',
      To: '+10987654321',
      Body: message_body,
      SmsStatus: 'delivered'
    } }

    context "When the message does not contain a keyword" do
      let(:message_body) { 'Hello!' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            "PLACEHOLDER AUTORESPONSE"
          )
        expect {
          post :incoming_message, params: params
        }.to_not change { ConsentChange.count }
      }
    end

    context "When the message is an english opt-in keyword" do
      let(:message_body) { 'STARTTEST' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { snap.opt_in_response }
          )
        expect {
          post :incoming_message, params: params
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: true,
                sms_message: anything,
                program: snap
              )
      }
    end

    context "When the message is a non-Twilio-handled english help keyword" do
      let(:message_body) { 'INFOTEST' }
      specify {
        expect_any_instance_of(MessageService).to receive(:send_message).with(
          anything,
          Mobility.with_locale(:en) { snap.help_response }
        )
        post :incoming_message, params: params
      }
    end

    context "When the message is a non-Twilio-handled spanish help keyword" do
      let(:message_body) { 'INFOTESTSPANISH' }
      specify {
        expect_any_instance_of(MessageService).to receive(:send_message).with(
          anything,
          Mobility.with_locale(:es) { snap.help_response }
        )
        post :incoming_message, params: params
      }
    end

    context "When the message is a Twilio-handled keyword" do
      let(:message_body) { 'HELP' }
      specify {
        expect_any_instance_of(MessageService).to_not receive(:send_message)
        post :incoming_message, params: params
      }
    end

    context "When the message is an english opt-out keyword" do
      let(:message_body) { 'STOPTEST' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { snap.opt_out_response }
          )
        expect {
          post :incoming_message, params: params
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: anything,
                program: snap
              )
      }
    end

    context "When the message is a keyword with mixed case" do
      let(:message_body) { 'sToPtEsT' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { snap.opt_out_response }
          )
        expect {
          post :incoming_message, params: params
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: anything,
                program: snap
              )
      }
    end

    context "When the message contains a keyword and additional text" do
      let(:message_body) { 'stoptest please' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            "PLACEHOLDER AUTORESPONSE"
          )
        expect {
          post :incoming_message, params: params
        }.to_not change { ConsentChange.count }
      }
    end

    context "When the message is a spanish opt-out keyword" do
      before {
        Mobility.with_locale(:es) { snap.opt_out_response = "Adios" }
        snap.save
      }

      let(:message_body) { 'STOPTESTSPANISH' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:es) { snap.opt_out_response }
          )
        expect {
          post :incoming_message, params: params
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: anything,
                program: snap
              )
      }
    end

    context "When there are multiple programs" do
      let(:wic) { create(
        :program,
        name: "WIC",
        opt_in_keywords: { en: ["STARTWIC"], es: ["STARTWICSPANISH"] },
        opt_out_keywords: { en: ["STOPWIC"], es: ["STOPWICSPANISH"] },
        opt_in_response: "Hello from WIC!",
        opt_out_response: "Goodbye from WIC!"
      ) }

      let(:message_body) { 'STOPWIC' }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { wic.opt_out_response }
          )
        expect {
          post :incoming_message, params: params
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: anything,
                program: wic
              )
      }
    end

  end

end