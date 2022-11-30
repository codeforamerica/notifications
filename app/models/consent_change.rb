# == Schema Information
#
# Table name: consent_changes
#
#  id             :bigint           not null, primary key
#  change_source  :string           not null
#  new_consent    :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  program_id     :bigint
#  sms_message_id :bigint
#
# Indexes
#
#  index_consent_changes_on_program_id      (program_id)
#  index_consent_changes_on_sms_message_id  (sms_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (sms_message_id => sms_messages.id)
#
class ConsentChange < ApplicationRecord
  belongs_to :sms_message
  belongs_to :program
end
