# == Schema Information
#
# Table name: recipients
#
#  id                    :bigint           not null, primary key
#  phone_number          :string           not null
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
  message_batch = MessageBatch.new

  context "when the phone number is valid" do
    subject { described_class.new(message_batch: message_batch, phone_number: '+11234567890', program_case_id: 'DONT_CARE') }
    it { is_expected.to be_valid }
  end

  context "when the phone number includes spurious characters" do
    subject { described_class.new(message_batch: message_batch, phone_number: '+1123456789A', program_case_id: 'DONT_CARE') }
    it "is invalid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:phone_number]).to eq ['+1123456789A is not a valid phone number']
    end
  end

  context "when the phone number is too long" do
    subject { described_class.new(message_batch: message_batch, phone_number: '+112345678901', program_case_id: 'DONT_CARE') }
    it "is invalid" do
      expect(subject).not_to be_valid
      expect(subject.errors[:phone_number]).to eq ['+112345678901 is not a valid phone number']
    end
  end
end
