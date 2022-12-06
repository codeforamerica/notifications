FactoryBot.define do
  factory :consent_change do
    transient do
      phone_number { 1234567890 }
      created_at { DateTime.now }
    end

    new_consent { false }
    change_source { 'sms' }
    sms_message
    program { program }

    after(:build) do |consent_change, evaluator|
      consent_change.sms_message.from = evaluator.phone_number
    end
  end
end