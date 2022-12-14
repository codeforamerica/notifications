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
FactoryBot.define do
  factory :message_template do
    transient do
      english_body { 'Simple message body' }
      spanish_body { 'Cuerpo de mensaje sencillo' }
    end

    name { 'SimpleMessage' }

    after(:build) do |message_template, evaluator|
      Mobility.with_locale(:en) { message_template.body = evaluator.english_body }
      Mobility.with_locale(:es) { message_template.body = evaluator.spanish_body }
    end
  end
end
