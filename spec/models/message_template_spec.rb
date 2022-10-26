# == Schema Information
#
# Table name: message_templates
#
#  id         :bigint           not null, primary key
#  body       :jsonb
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_message_templates_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe MessageTemplate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
