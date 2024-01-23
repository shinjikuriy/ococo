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
  factory :pickle, aliases: [:pickle_daikon] do
    name { "大根のはりはり漬け" }
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
    note { "保存袋に入れて輪ゴムで口を縛るときに、大根がつけ汁に浸っている状態にすること。"}
  end

  factory :pickle_kabu, class: Pickle do
    name { 'かぶの甘酢漬け' }
    preparation { nil }
    process { <<~End
    かぶは厚さ2〜3mmの半月切りにする。
    保存袋にかぶと塩を入れて袋ごともみ込み、塩を全体になじませる。
    しんなりしたら袋の空気を抜いて口を閉じ、重しを乗せて2〜3時間ほど置く。
    かぶをザルに上げて水気を切り、キッチンペーパーでさらに水分を取る。
    保存袋に株を入れて、あとからつけ汁を加えもみ込んでなじませる。
    袋の空気を抜きながら口を閉じ、冷蔵庫で1日ほど置く。
    End
    }
    note { '赤唐辛子はちぎって加えるとよい。'}
  end
end
