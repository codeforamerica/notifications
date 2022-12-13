# == Schema Information
#
# Table name: programs
#
#  id               :bigint           not null, primary key
#  help_keywords    :jsonb            not null
#  help_response    :jsonb            not null
#  name             :string           not null
#  opt_in_keywords  :jsonb            not null
#  opt_in_response  :jsonb            not null
#  opt_out_keywords :jsonb            not null
#  opt_out_response :jsonb            not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Program, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
