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
FactoryBot.define do
  factory :message_batch do
    message_template
    program
  end
end
