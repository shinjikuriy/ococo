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
    display_name { user.username }
    prefecture { 'unselected' }
    association :user
  end
end
