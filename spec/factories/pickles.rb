# == Schema Information
#
# Table name: pickles
#
#  id          :bigint           not null, primary key
#  user_id     :bigint
#  name        :string
#  started_on  :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  preparation :text
#  process     :text
#  note        :text
#
FactoryBot.define do
  factory :pickle do
    user_id { 1 }
    name { "大根のはりはり漬け" }
    started_on { "2024-01-19" }
    preparation { "大根を短冊切りにして天日干しにする。" }
    process { <<~End
    ごぼうはささがきに、しょうがは千切りにする。
    鍋に湯を沸かし、酢を入れ、ごぼうを30秒ほど湯通ししてザルに上げる。水気を切って冷ましておく。
    鍋に漬け汁の材料を入れて沸騰するまでかき混ぜ、砂糖を溶かす。鍋かボウルに天日干しした大根を入れて温めたつけ汁を回しかけ、2時間ほど冷ます。
    ボウルからつけ汁を鍋に取り出し、再度煮てアクを取る。
    大根が入ったボウルに、ごぼう、しょうがを入れ、つけ汁を再度かけて冷暗所で1日置く。
    味見をして、味を足す場合は漬け汁でもう一度煮る。
    保存袋に移し、輪ゴムで口を縛り冷暗所で2日ほど置く。
    End
    }
  end
end
