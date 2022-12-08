# == Schema Information
#
# Table name: message_batches
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  message_template_id :bigint           not null
#  program_id          :bigint
#
# Indexes
#
#  index_message_batches_on_message_template_id  (message_template_id)
#  index_message_batches_on_program_id           (program_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_template_id => message_templates.id)
#
require 'rails_helper'

RSpec.describe MessageBatch, type: :model do
  ActiveJob::Base.queue_adapter = :test

  let (:message_batch) { create(:message_batch) }
  let (:recipient) { create(:recipient, message_batch: message_batch, sms_status: sms_status) }

  describe "#perform_later" do
    context "when the recipient has not yet been sent a message" do
      let (:sms_status) { :imported }
      it "schedules a job" do
        expect {
          message_batch.send_messages
        }.to have_enqueued_job.on_queue(:default).with(recipient.id)
      end
    end
    context "when the recipient has already been sent a message" do
      let (:sms_status) { :api_success }
      it "schedules a job" do
        expect {
          message_batch.send_messages
        }.not_to have_enqueued_job.on_queue(:default).with(recipient.id)
      end
    end
    end
end
