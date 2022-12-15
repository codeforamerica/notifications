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
#  from          :string           not null
#  message_sid   :string
#  status        :enum             not null
#  to            :string           not null
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
class SmsMessage < ApplicationRecord
  include PhoneNumberMethods
  belongs_to :recipient, optional: true
  validates :from, presence: true, phone_number: true
  validates :to, presence: true, phone_number: true
  clean_phone_numbers :from
  clean_phone_numbers :to

  enum :direction, { inbound: "inbound",
                     outbound_api: "outbound-api",
                     outbound_call: "outbound-call",
                     outbound_reply: "outbound-reply"
  }, prefix: :direction
  enum :status, { accepted: "accepted",
                  scheduled: "scheduled",
                  canceled: "canceled",
                  queued: "queued",
                  sending: "sending",
                  sent: "sent",
                  failed: "failed",
                  delivered: "delivered",
                  undelivered: "undelivered",
                  receiving: "receiving",
                  received: "received",
                  read: "read",
  }, prefix: :status
end
