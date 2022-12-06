FactoryBot.define do
  factory :consent_change do
    change_source { 'manual' }
    # transient do
    #   r {
    #     recipient {
    #       phone_number { 1234567890 }
    #     }
    #   }
    #   created_at { DateTime.now }
    # end
    #
    # new_consent { false }
    # change_source { 'sms' }
    # sms_message {
    #   sms_message {
    #     from { r.phone_number }
    #   }
    # }
    # program { program }
  end
end