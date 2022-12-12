require 'rails_helper'

describe ConsentService do

  let(:snap) { create(:program) }
  let(:recipient) { create(:recipient) }

  describe "#check_consent" do

    context "When no program is specified" do
      specify {
        expect(described_class.new.check_consent(recipient, nil)).to eq(true)
      }
    end

    context "When there is no consent change for this program" do
      specify {
        expect(described_class.new.check_consent(recipient, snap)).to eq(true)
      }
    end

    context "When there are multiple consent changes for this program" do

      context "and the most recent change grants consent" do
        specify {

          create(:consent_change, new_consent: false, program: snap, phone_number: recipient.phone_number, created_at: DateTime.now - 2)
          create(:consent_change, new_consent: true, program: snap, phone_number: recipient.phone_number, created_at: DateTime.now - 1)
          expect(described_class.new.check_consent(recipient, snap)).to eq(true)
        }
      end

      context "and the most recent change revokes consent" do
        specify {
          create(:consent_change, new_consent: true, program: snap, phone_number: recipient.phone_number, created_at: DateTime.now - 2)
          create(:consent_change, new_consent: false, program: snap, phone_number: recipient.phone_number, created_at: DateTime.now - 1)
          expect(described_class.new.check_consent(recipient, snap)).to eq(false)
        }
      end

      context "and the most recent consent change for another program disagrees with this one" do
        let(:ccap) { create(:program, name: "CCAP") }
        specify {
          create(:consent_change, new_consent: false, program: ccap, phone_number: recipient.phone_number, created_at: DateTime.now - 1)

          expect(described_class.new.check_consent(recipient, snap)).to eq(true)
        }
      end

    end

  end

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
            Mobility.with_locale(:en) { snap.opt_in_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: true,
                sms_message: sms_message,
                program: snap
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
            Mobility.with_locale(:en) { snap.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: snap
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
            Mobility.with_locale(:en) { snap.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: snap
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
        Mobility.with_locale(:es) { snap.opt_out_response = "Adios" }
        snap.save
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
            Mobility.with_locale(:es) { snap.opt_out_response }
          )
        expect {
          described_class.new.process_consent_change(sms_message)
        }.to change { ConsentChange.count }.from(0).to(1)
        expect(ConsentChange.last)
          .to have_attributes(
                new_consent: false,
                sms_message: sms_message,
                program: snap
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