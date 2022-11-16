# == Schema Information
#
# Table name: recipients
#
#  id                    :bigint           not null, primary key
#  phone_number          :string           not null
#  preferred_language    :enum
#  sms_api_error_code    :string
#  sms_api_error_message :string
#  sms_status            :enum             default("imported"), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  message_batch_id      :bigint
#  program_case_id       :string
#
# Indexes
#
#  index_recipients_on_message_batch_id  (message_batch_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_batch_id => message_batches.id)
#
require 'rails_helper'

RSpec.describe Recipient, type: :model do
  subject(:recipient) { build(:recipient, phone_number: phone_number) }

  context "when the phone number has no country code and all 10 digits" do
    let(:phone_number) { '1234567890' }
    it { is_expected.to be_valid }
  end

  context "when the phone number has a country code plus 10 digits" do
    let(:phone_number) { '11234567890' }
    it "is cleaned up so that it is valid" do
      subject.save
      expect(subject.phone_number).to eq '1234567890'
    end
  end

  context "when the phone number includes extra non-digit characters" do
    let(:phone_number) { '1 (123) 456-7890 extra' }
    it "is cleaned up so that it is valid" do
      subject.save
      expect(subject.phone_number).to eq '1234567890'
    end
  end

  context "when the phone number has more than 10 digits" do
    let(:phone_number) { '+112345678901' }
    it "is invalid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:phone_number]).to eq ['+112345678901 is not a valid phone number']
    end
  end
end
