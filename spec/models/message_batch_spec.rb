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
require 'rails_helper'

RSpec.describe MessageBatch, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
