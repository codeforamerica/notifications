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
FactoryBot.define do
  factory :recipient do
    message_batch
    program_case_id { '123' }
    phone_number { '4155551212' }
    preferred_language { :en }
  end
end
