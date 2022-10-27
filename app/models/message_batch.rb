# == Schema Information
#
# Table name: message_batches
#
#  id                  :bigint           not null, primary key
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  message_template_id :bigint           not null
#
# Indexes
#
#  index_message_batches_on_message_template_id  (message_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (message_template_id => message_templates.id)
#
class MessageBatch < ApplicationRecord
  belongs_to :message_template
end
