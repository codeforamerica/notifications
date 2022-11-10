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
FactoryBot.define do
  factory :program do
    name { "SNAP" }
    opt_in_keywords { {en: ["STARTTEST"], es: ["STARTTESTSPANISH"]} }
    opt_out_keywords { {en: ["STOPTEST"], es: ["STOPTESTSPANISH"]} }
    opt_in_response { "HelloTest" }
    opt_out_response { "GoodbyeTest" }
  end
end
