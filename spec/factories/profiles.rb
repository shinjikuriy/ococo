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
  factory :profile do
    display_name { 'ルーカス🐻' }
    prefecture { 'kanagawa' }
    description { 'ドイツ出身です。よろしくお願いします。' }
    x_username { 'luke_x' }
    ig_username { 'luke_ig' }
  end
end
