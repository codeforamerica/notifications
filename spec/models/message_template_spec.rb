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
  subject(:message_template) { build(:message_template) }
  it "stores a message body in different locales" do
    expect(subject.body).to eq('Simple message body')
    Mobility.with_locale(:es) { expect(subject.body).to eq('Cuerpo de mensaje sencillo') }
  end

  context "when no translation is available for a supported locale" do
    let (:message_template) { MessageTemplate.new(name: 'English only message', body: 'Body in English only')}
    it "defaults to the default locale" do
      Mobility.with_locale(:es) { expect(message_template.body).to eq('Body in English only') }
    end
  end
end
