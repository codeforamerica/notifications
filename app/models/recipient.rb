# == Schema Information
#
# Table name: recipients
#
#  id               :bigint           not null, primary key
#  phone_number     :string
#  program          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  message_batch_id :bigint           not null
#  program_case_id  :string
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
end
