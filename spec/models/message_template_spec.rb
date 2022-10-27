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
  it "stores a body in different locales" do
    message_template = MessageTemplate.new(name: 'Message1', body: 'Message body in English')
    Mobility.with_locale(:es) { message_template.body = 'Cuerpo del mensaje en español' }
    expect(message_template.body).to eq('Message body in English')
    Mobility.with_locale(:es) { expect(message_template.body).to eq('Cuerpo del mensaje en español') }
  end

  context "when no translation is available for a supported locale" do
    it "defaults to the default locale" do
      message_template = MessageTemplate.new(name: 'Message1', body: 'Message body')
      Mobility.with_locale(:es) { expect(message_template.body).to eq('Message body') }
    end
  end
end
