# == Schema Information
#
# Table name: consent_changes
#
#  id              :bigint           not null, primary key
#  change_source   :string
#  new_consent     :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sms_messages_id :bigint
#
# Indexes
#
#  index_consent_changes_on_sms_messages_id  (sms_messages_id)
#
# Foreign Keys
#
#  fk_rails_...  (sms_messages_id => sms_messages.id)
#
require 'rails_helper'

RSpec.describe ConsentChange, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
