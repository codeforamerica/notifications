require 'rails_helper'

describe ConsentService do

  let(:program) { create(:program) }

  describe "#process_consent_change" do
    context "When the message does not contain an opt-in or opt-out keyword" do
      let(:sms_message) { build(
        :sms_message,
        body: "Hello!",
        direction: :inbound
      ) }
      specify {
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to_not change { ConsentChange.count }
      }
    end

    context "When the message is an english opt-in keyword" do
      let(:sms_message) { build(
          :sms_message,
          body: "STARTTEST",
          direction: :inbound
        )
      }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { program.opt_in_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: true,
                sms_message: sms_message,
                program: program
              )
      }
    end

    context "When the message is an english opt-out keyword" do
      let(:sms_message) { build(
        :sms_message,
        body: "STOPTEST",
        direction: :inbound
      ) }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { program.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: program
              )
      }
    end

    context "When the message is a keyword with mixed case" do
      let(:sms_message) { build(
        :sms_message,
        body: "sToPtEsT",
        direction: :inbound
      ) }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { program.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: program
              )
      }
    end

    context "When the message contains a keyword and additional text" do
      let(:sms_message) { build(
        :sms_message,
        body: "stoptest please",
        direction: :inbound
      ) }
      specify {
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to_not change { ConsentChange.count }
      }
    end

    context "When the message is a spanish opt-out keyword" do
      before {
        Mobility.with_locale(:es) { program.opt_out_response = "Adios" }
        program.save
      }

      let(:sms_message) { build(
        :sms_message,
        body: "STOPTESTSPANISH",
        direction: :inbound
      ) }

      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:es) { program.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: program
              )
      }
    end

    context "When there are multiple programs" do
      let(:wic) { create(
        :program,
        name: "WIC",
        opt_in_keywords: {en: ["STARTWIC"], es: ["STARTWICSPANISH"]},
        opt_out_keywords: {en: ["STOPWIC"], es: ["STOPWICSPANISH"]},
        opt_in_response: "Hello from WIC!",
        opt_out_response: "Goodbye from WIC!"
      ) }

      let(:sms_message) { build(
        :sms_message,
        body: "STOPWIC",
        direction: :inbound
      ) }
      specify {
        expect_any_instance_of(MessageService)
          .to receive(:send_message).with(
            anything,
            Mobility.with_locale(:en) { wic.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: wic
              )
      }
    end

  end

end