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
  subject(:message_template) { build(:message_template, body: 'Message body in English') }
  it "stores a message body in different locales" do
    subject.body_backend.write(:es, 'Cuerpo del mensaje en español')
    expect(subject.body).to eq('Message body in English')
    Mobility.with_locale(:es) { expect(subject.body).to eq('Cuerpo del mensaje en español') }
  end

  context "when no translation is available for a supported locale" do
    it "defaults to the default locale" do
      Mobility.with_locale(:es) { expect(subject.body).to eq('Message body in English') }
    end
  end
end
