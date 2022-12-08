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
class Recipient < ApplicationRecord
  include PhoneNumberMethods
  belongs_to :message_batch, optional: true
  has_one :sms_message
  validates :phone_number, presence: true, phone_number: true
  validates :program_case_id, presence: true, if: -> { message_batch.present? }
  validates :preferred_language, presence: true, if: -> { message_batch.present? }

  clean_phone_numbers :phone_number

  scope :imported, -> { where(sms_status: :imported) }
end
