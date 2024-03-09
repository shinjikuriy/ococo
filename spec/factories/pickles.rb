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
    process do
      <<~End
      ごぼうはささがきに、しょうがは千切りにする。
      鍋に湯を沸かし、酢を入れ、ごぼうを30秒ほど湯通ししてザルに上げる。水気を切って冷ましておく。
      鍋に漬け汁の材料を入れて沸騰するまでかき混ぜ、砂糖を溶かす。鍋かボウルに天日干しした大根を入れて温めたつけ汁を回しかけ、2時間ほど冷ます。
      ボウルからつけ汁を鍋に取り出し、再度煮てアクを取る。
      大根が入ったボウルに、ごぼう、しょうがを入れ、つけ汁を再度かけて冷暗所で1日置く。
      味見をして、味を足す場合は漬け汁でもう一度煮る。
      保存袋に移し、輪ゴムで口を縛り冷暗所で2日ほど置く。
      End
    end
    note { "保存袋に入れて輪ゴムで口を縛るときに、大根がつけ汁に浸っている状態にすること。"}
    ingredients_attributes do
      [{ name: '大根', quantity: '500g' },
       { name: 'ごぼう', quantity: '75g' },
       { name: 'しょうが', quantity: '1かけら' }]
    end
    sauce_materials_attributes do
      [{ name: '中ザラ糖', quantity: '50g' },
       { name: '醤油', quantity: '100ml' },
       { name: '酢', quantity: '75ml' },
       { name: '顆粒和風だし', quantity: '大さじ1/2' },
       { name: '赤唐辛子', quantity: '1〜2本' }]
    end
  end

  factory :pickle_kabu, class: Pickle do
    name { 'かぶの甘酢漬け' }
    preparation { nil }
    process do
      <<~End
      かぶは厚さ2〜3mmの半月切りにする。
      保存袋にかぶと塩を入れて袋ごともみ込み、塩を全体になじませる。
      しんなりしたら袋の空気を抜いて口を閉じ、重しを乗せて2〜3時間ほど置く。
      かぶをザルに上げて水気を切り、キッチンペーパーでさらに水分を取る。
      保存袋に株を入れて、あとからつけ汁を加えもみ込んでなじませる。
      袋の空気を抜きながら口を閉じ、冷蔵庫で1日ほど置く。
      End
    end
    note { '赤唐辛子はちぎって加えるとよい。'}
    ingredients_attributes do
      [{ name: 'かぶ', quantity: '1kg' },
       { name: '塩', quantity: '35g' }]
    end
    sauce_materials_attributes do
      [{ name: '中ザラ糖', quantity: '80〜100g' },
       { name: '酢', quantity: '60ml' },
       { name: '赤唐辛子', quantity: '2〜3本' },
       { name: 'レモン汁(ゆずでも可)', quantity: '適量' }]
    end
  end

  factory :pickle_celery, class: Pickle do
    name { 'セロリとパプリカのピクルス' }
    preparation { '' }
    process do
      <<~End
      セロリは筋を取り、好みの大きさに切る。
      パプリカは縦に細切りにする。セロリと合わせてボウルに入れる。
      セロリとパプリカを鍋に入れ火にかけて、混ぜながらしっかりと煮溶かし、冷めないうちにセロリとパプリカにかける。
      ボウルをよく振って冷まし終えたら完成。保存容器に移し替え、漬け汁に野菜が浸るような状態で保存する。
      End
    end
    note { 'セロリの表面は硬いので筋取りを。包丁の刃を立てこそぐか、ピーラーを使うと簡単。'}
    ingredients_attributes do
      [{ name: 'セロリ', quantity: '500g' },
       { name: 'パプリカ', quantity: '1/2個' }]
    end
    sauce_materials_attributes do
      [{ name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' },
       { name: '酒', quantity: '大さじ1' },
       { name: 'みりん', quantity: '大さじ1' }]
    end
  end

  factory :pickle_crimson, class: Pickle do
    name { '幻想のクリムゾンスパイス漬け' }
    ingredients_attributes do
      [{ name: 'クリムゾンペトール', quantity: '1つ' },
       { name: '空中の輝き', quantity: '1つまみ' }]
    end
    sauce_materials_attributes do
      [{ name: 'エターナルシナモン', quantity: '小さじ1' },
       { name: 'フェザーオブゴースト', quantity: '3枚' },
       { name: 'シャドウピクルス', quantity: '300g' },
       { name: '銀河の泉', quantity: '適量' }]
    end
    preparation do
      <<~End
      クリムゾンペトールの花びらを取り出し、花の魔法を感じるように大切に保管する。
      シャドウピクルスは適当な大きさに切り、銀河の泉にさらして洗う。
      End
    end
    process do
      <<~End
      クリムゾンペトールの花びらを器に添え、空中の輝きとエターナルシナモンを加えて混ぜる。
      フェザーオブゴーストを優雅に添え、シャドウピクルスを加え、全体が均一に混ざるまで静かに混ぜる。
      最後に銀河の泉を優しくかけ、漬物全体に幻想的な輝きを添える。
      End
    end
    note do
      <<~End
      クリムゾンペトールの花びらは繊細なので、丁寧に扱い、花の魔法を漬物にうまく移すことがポイントです。
      エターナルシナモンは強すぎないように注意し、漬物に独自の永遠の香りを与えます。
      漬物が仕上がったら、特別な日や不思議な雰囲気の中で召し上がってみてください。
      End
    end
  end

  factory :pickle_elf, class: Pickle do
    name { 'エルフのエメラルド漬け' }
    preparation { 'エルフの秘薬を使用し、材料を魔法の力で浸透させる。' }
    process do
      <<~End
      エメラルド色の魔法の漬け汁を用意し、深いボウルにセロリとアンコウの尾を入れる。
      エルフの秘薬を振りかけ、漬け汁が材料全体に均等に行き渡るように丁寧に混ぜる。
      低い温度で魔法の火を灯し、漬け汁が微細な泡を立てるまで加熱する。冷ましてから再度混ぜ、エメラルド色が一層際立つようにする。
      エルフのエメラルド漬けを保存容器に移し、冷蔵庫で魔法の効力を保ちつつ、美味しく漬け込む。
      End
    end
    note { 'エルフの秘薬は市場では手に入りにくいが、代わりに緑茶を使用することもできます。' }
    ingredients_attributes do
      [{ name: 'セロリ', quantity: '500g' },
       { name: 'アンコウの尾', quantity: '1/4本' }]
    end
    sauce_materials_attributes do
      [{ name: 'エルフの秘薬', quantity: '少々' },
       { name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' },
       { name: '魔法のエメラルド色漬け汁', quantity: '300ml' }]
    end
  end

  factory :pickle_galactic, class: Pickle do
    name { '宇宙旅行ピクルス' }
    preparation { '星の粉末を使用して、材料に宇宙のエッセンスを吸収させる。' }
    process do
      <<~End
      銀河の果樹から収穫した異星のフルーツと、宇宙の海で取れた流れ星の粉末を深いボウルに合わせる。
      星のエッセンスを均等に材料に広がるように混ぜ、宇宙の風味を感じられるようにする。
      小さな宇宙船を使って、ピクルスを軌道に乗せ、宇宙空間で自然発酵させる。地球外の微生物が独特の風味を生み出す。
      地球に帰還後、宇宙旅行ピクルスを保存容器に封じ込め、冷蔵庫で冷やしながら宇宙の味わいを楽しむ。
      End
    end
    note { '星の粉末はオンラインの宇宙食専門店で入手可能。宇宙旅行ピクルスは地球の常識を超えた味わいが楽しめます。'}
    ingredients_attributes do
      [{ name: '異星のフルーツ', quantity: '300g' },
       { name: '流れ星の粉末', quantity: '少々' }]
    end
    sauce_materials_attributes do
      [{ name: '星のエッセンス', quantity: '適量' },
       { name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' },
       { name: '宇宙の風味漬け汁', quantity: '200ml' }]
    end
  end

  factory :pickle_mystical, class: Pickle do
    name { '秘境のマジカルピクルス' }
    preparation { '古代の秘伝の呪文を唱え、材料に異次元の香りを宿す。' }
    process do
      <<~End
      古代の秘境に住む謎の植物と、山の中で採れた奇妙なキノコを慎重に切りそろえ、ボウルに並べる。
      魔法陣のようなパターンで結ばれた呪文の漬け汁を準備し、材料を包み込むように混ぜ込む。
      材料が異次元のエネルギーを取り込むまで、静かな場所で寝かせ、神秘的な風味を引き立てる。
      秘境のマジカルピクルスは、保存容器に封じ込められ、特別な時に食べると、異世界へのドアが開かれるような不思議な体験ができます。
      End
    end
    note { '謎の植物や奇妙なキノコは、地元の山で手に入るものを使用してください。漬け汁の呪文は独自のものを詠唱してください。'}
    ingredients_attributes do
      [{ name: '秘境の謎の植物', quantity: '300g' },
       { name: '奇妙な山キノコ', quantity: '200g' }]
    end
    sauce_materials_attributes do
      [{ name: '魔法陣の呪文漬け汁', quantity: '適量' },
       { name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' }]
    end
  end

  factory :pickle_artisan, class: Pickle do
    name { 'アーティザンの特製ピクルス' }
    preparation { '地元の農園から直送された有機野菜と、古くから伝わる伝統的な手法で漬け込む。' }
    process do
      <<~End
      地元の有機農園から届いた新鮮なキュウリとカラフルなパプリカを手で切りそろえ、丁寧にボウルに詰める。
      町の川でとれた新鮮な川エビを加え、伝統的な塩漬けの手法を用いて、材料を均等になじませる。
      陽の光を浴びた農園で数日寝かせ、自然の恵みと手作業の愛情をピクルスに注ぎ込む。
      アーティザンの特製ピクルスは、地元の味わいと手仕事の温もりを感じながら、保存容器で大切に保管してください。
      End
    end
    note { '有機野菜と新鮮な川エビは地元の農園や漁師から手に入ります。手作業で行う伝統的な塩漬けは、ピクルスに豊かな風味をもたらします。'}
    ingredients_attributes do
      [{ name: '有機キュウリ', quantity: '500g' },
       { name: 'カラフルなパプリカ', quantity: '200g' },
       { name: '新鮮な川エビ', quantity: '150g' }]
    end
    sauce_materials_attributes do
      [{ name: '塩漬けの手法', quantity: '適量' },
       { name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' }]
    end
  end

  factory :pickle_nostalgic, class: Pickle do
    name { '懐かしのご家庭ピクルス' }
    preparation { '祖母の伝統レシピを踏襲し、地元の市場で手に入る身近な食材を使用。' }
    process do
      <<~End
      地元の市場で仕入れた新鮮なズッキーニとにんじんを切りそろえ、ボウルに優しく盛り付ける。
      祖母の秘伝の漬け汁を使用し、材料に丁寧に染み込ませる。手間暇かけた味わいを感じるため、ゆっくりと寝かせる。
      家庭のぬくもりが漂う懐かしのご家庭ピクルスは、保存容器に詰めて冷蔵庫で大切に保管してください。
      End
    end
    note { '祖母の秘伝の漬け汁は、家庭によって異なります。身近な市場で手に入る食材で、懐かしい味わいを再現してみてください。'}
    ingredients_attributes do
      [{ name: '新鮮なズッキーニ', quantity: '400g' },
       { name: 'にんじん', quantity: '200g' }]
    end
    sauce_materials_attributes do
      [{ name: '祖母の秘伝の漬け汁', quantity: '適量' },
       { name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' }]
    end
  end

  factory :pickle_urban_hipster, class: Pickle do
    name { 'アーバンヒップスターのクラフトピクルス' }
    preparation { '地元のオーガニックフードフェスで手に入るユニークな食材を使い、独自のアーティズナルなピクルスを作る。' }
    process do
      <<~End
      グリーンマーケットで見つけた異国風の彩り野菜と、アンダーグラウンドな農家から届いた手摘みのガーデンハーブを鮮やかにボウルに組み合わせる。
      地元のクラフトビールをベースにしたピクルス用の液体を準備し、独自のアーティズナルな味わいを追求する。
      ゆるやかな街のビンテージストアで見つけた保存容器に入れ、カフェで流行りのビンテージ生活を感じながらピクルスを楽しむ。
      End
    end
    note { 'グリーンマーケットや農家直売などで手に入る異国風の野菜やクラフトビールは、個性的なピクルスを作り上げるポイントです。'}
    ingredients_attributes do
      [{ name: '彩り野菜アソート', quantity: '500g' },
       { name: '手摘みガーデンハーブ', quantity: '50g' }]
    end
    sauce_materials_attributes do
      [{ name: 'クラフトビールピクルス用液体', quantity: '300ml' },
       { name: '上白糖', quantity: '大さじ2' },
       { name: '塩', quantity: '10g' },
       { name: '酢', quantity: '大さじ2' }]
    end
  end

end
