FactoryBot.define do
  factory :recipient do
    message_batch
    program_case_id { '123' }
    phone_number { '4155551212' }
    preferred_language { :en }
  end
end
