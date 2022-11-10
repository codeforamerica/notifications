# == Schema Information
#
# Table name: programs
#
#  id               :bigint           not null, primary key
#  name             :string           not null
#  opt_in_keywords  :jsonb            not null
#  opt_in_response  :jsonb            not null
#  opt_out_keywords :jsonb            not null
#  opt_out_response :jsonb            not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Program < ApplicationRecord
  extend Mobility
  translates :opt_in_response, fallbacks: true
  translates :opt_out_response, fallbacks: true
end
