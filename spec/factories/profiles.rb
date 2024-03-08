# == Schema Information
#
# Table name: profiles
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  display_name :string(30)
#  prefecture   :integer          default("unselected"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  description  :text
#  x_username   :text
#  ig_username  :text
#
FactoryBot.define do
  factory :profile, aliases: [:profile_lukas] do
    display_name { 'ルーカス🐻' }
    prefecture { 'kanagawa' }
    description { 'ドイツ出身です。よろしくお願いします。' }
    x_username { 'luke_x' }
    ig_username { 'luke_ig' }
  end

  factory :profile_lena, class: Profile do
    display_name { 'レナ' }
    description { '漬け物初心者です' }
    ig_username { 'lena_ig' }
  end

  factory :profile_stefan, class: Profile do
    display_name { 'ステファン🐄' }
    prefecture { 'outside_of_japan' }
  end

  factory :profile_lorem, class: Profile do
    display_name { Faker::Games::Pokemon.name }
    prefecture { Profile.prefectures.keys.sample }
    description { Faker::Lorem.sentence }
    x_username { Faker::Internet.password max_length: 15 }
    ig_username { Faker::Internet.password }
  end
end
