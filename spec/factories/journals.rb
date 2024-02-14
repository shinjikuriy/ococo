# == Schema Information
#
# Table name: journals
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :journal do
    body { "前回は味が薄かったので、今回は塩を多くしてみた🧂 どうなるか楽しみ。" }
  end
end
