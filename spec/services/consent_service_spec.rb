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

end