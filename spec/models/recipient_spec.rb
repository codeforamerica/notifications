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
require 'rails_helper'

RSpec.describe Recipient, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
