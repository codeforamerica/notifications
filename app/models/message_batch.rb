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
class MessageBatch < ApplicationRecord
  belongs_to :message_template
  belongs_to :program
  has_many :recipients

  def send_messages
    recipient_ids = recipients.imported.pluck(:id).shuffle
    recipient_ids.each do |recipient_id|
      Rails.logger.info "Scheduling Recipient #{recipient_id}"
      SendMessageJob.perform_later recipient_id
    end
  end

  def get_localized_message_body(locale)
    Mobility.with_locale(locale) { message_template.body }
  end
end
