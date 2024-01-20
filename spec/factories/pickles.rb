# == Schema Information
#
# Table name: pickles
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  name       :string
#  started_on :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :pickle do
    user_id { 1 }
    name { "大根のはりはり漬け" }
    started_on { "2024-01-19" }
  end
end
