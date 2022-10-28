# == Schema Information
#
# Table name: recipients
#
#  id               :bigint           not null, primary key
#  phone_number     :string           not null
#  program          :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  message_batch_id :bigint           not null
#  program_case_id  :string           not null
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
  belongs_to :message_batch
  validates :phone_number, format: { with: /\A\+1\d{10}\z/, message: "%{value} is not a valid phone number"}
end
