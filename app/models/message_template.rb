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
class MessageTemplate < ApplicationRecord
  extend Mobility
  translates :body, fallbacks: true
  validates :name, presence: true, uniqueness: true
  validates :body, presence: true
end
