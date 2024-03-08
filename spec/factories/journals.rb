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

  factory :journal_sequence, class: Journal do
    sequence(:body) { |n| "いま#{n}回目の味見をしてみた。だんだん味が濃くなる気がする🌿" }
  end

  factory :journal_lorem, class: Journal do
    body { Faker::Lorem.sentence(word_count: 10) }
  end

  factory :journal_long, class: Journal do
    body { "土手の下で、分れ際に、やや遠ざかって、見返った時――その紫の深張を帯のあたりで横にして、少し打傾いて、黒髪の頭おもげに見送っていた姿を忘れぬ。どんなに潮に乱れたろう。渚の砂は、崩しても、積る、くぼめば、たまる、音もせぬ。ただ美しい骨が出る。貝の色は、日の紅、渚の雪、浪の緑。"}
  end
end
