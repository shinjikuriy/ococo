require 'factory_bot_rails'
require 'faker'

usernames = %w[demo_user01 demo_user02 demo_user03 demo_user04 demo_user05]

journal_fixtures = [
  "漬物の熟成プロセスを観察中。数週間たち、野菜の食感が変化。独自の味わいが広がり、これまでの試行錯誤が実りました。手作りの漬物、一つ一つが大切な時間の積み重ね。",
  "漬物の熟成、更なる深みを追求中。香りが引き立ち、野菜がまろやかになっています。手間暇かけた甲斐がありますね。",
  "漬物日記🥒 熟成過程を振り返りつつ、今日は新たな調味料を試しました。驚きの味わいにワクワク！自家製の楽しみ、止まらない。",
  "漬物の変化に感慨深く。特に色合いが鮮やかに。自家製ならではの美しさと味わい、心から愛しています。",
  "漬物の進化に感動。熟成が進むにつれて、味の奥行きが増し、まさにアートのような美味しさ。手作り漬物の世界、深淵です。",
  "漬物の熟成を見守る日々。今日は気温の変化で味に微妙な変化あり。野菜との対話、毎日が新しい発見。",
  "漬物の熟成日記📆 一週間前の自分に感謝。時間をかけた甲斐があり、今では深い味わいが広がります。手作りの味わい深さ、最高です。",
  "漬物の進化に興奮中。熟成の絶妙なタイミングで、野菜が絶品の食感へ。手作りならではの愛情が、味に表れている気がします。",
  "漬物日誌📓 今日は特別な日。漬物の熟成がピークに達し、自家製の楽しさが最大限に引き立ちました。感動の瞬間です。",
  "漬物の変化に驚きと感慨。手作りのプロセスが、味わい深さに繋がっていく。漬物愛、どこまでも深まるばかり。",
  "漬物プロジェクト🌱 熟成5日目。早めに味見。酸味がしっかりと感じられ、野菜がまさにハーモニー。自分で育てた野菜での漬物、最高のご褒美です。"
]

# Create demo users with edited profiles
usernames.each do |username|
  unless user = User.find_by(username: username)
    user = User.create!(FactoryBot.attributes_for(:user_lorem, username: username))
    user.confirm
    user.profile.update(FactoryBot.attributes_for(:profile_lorem))
  end

  next if user.pickles.present?
  user.pickles.create!(FactoryBot.attributes_for(:pickle_urban_hipster))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_nostalgic))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_artisan))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_mystical))
  user.pickles.create!(FactoryBot.attributes_for(:pickle_galactic))
end

# Create demo journals
usernames.each do |username|
  user = User.find_by(username: username)
  user.pickles.each do |pickle|
    next if pickle.journals.present?
    15.times do
      body = journal_fixtures.sample
      pickle.journals.create!(body: body)
    end
  end
end

# Edit creation time
time = Time.zone.now
user_ids = User.where(username: usernames).pluck(:id)
pickle_ids = Pickle.where(user_id: user_ids).pluck(:id).shuffle
journal_ids = Journal.where(pickle_id: pickle_ids).pluck(:id).shuffle

pickle_ids.each do |id|
  time = time - 3.hours
  Pickle.update!(id, created_at: time)
end

time = Time.zone.now
journal_ids.each do |id|
  time = time - 1.hour
  Journal.update!(id, created_at: time)
end



