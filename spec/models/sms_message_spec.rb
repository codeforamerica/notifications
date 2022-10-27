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
#
require 'rails_helper'

RSpec.describe SmsMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
