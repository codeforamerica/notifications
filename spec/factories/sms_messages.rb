# == Schema Information
#
# Table name: sms_messages
#
#  id            :bigint           not null, primary key
#  body          :text
#  date_created  :datetime
#  date_sent     :datetime
#  date_updated  :datetime
#  direction     :enum             not null
#  error_code    :string
#  error_message :string
#  from          :string
#  message_sid   :string
#  status        :enum             not null
#  to            :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recipient_id  :bigint
#
# Indexes
#
#  index_sms_messages_on_recipient_id  (recipient_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipient_id => recipients.id)
#
FactoryBot.define do
  factory :sms_message do
    body { 'message body' }
    direction { :inbound }
    status { :delivered }
    from { '4155551212' }
    to { '5105551212' }
  end
end
