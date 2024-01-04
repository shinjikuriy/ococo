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
class Profile < ApplicationRecord
  belongs_to :user

  enum :prefecture, %i[unselected
                       hokkaido
                       aomori iwate miyagi akita yamagata fukushima
                       ibaraki tochigi gunma saitama chiba tokyo kanagawa
                       niigata toyama ishikawa fukui yamanashi nagano gifu shizuoka aichi
                       mie shiga kyoto osaka hyogo nara wakayama
                       tottori shimane okayama hiroshima yamaguchi
                       tokushima kagawa ehime kochi
                       fukuoka saga nagasaki kumamoto oita miyazaki kagoshima okinawa
                       outside_japan], prefix: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  validates :display_name, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 160 }
  validates :x_username, length: { maximum: 15 },
                         format: { with: /\A[a-zA-Z0-9_]+\z/, message: :invalid_username_format }
  validates :ig_username, length: { maximum: 30 },
                          format: { with: /\A[a-zA-Z0-9_.]+\z/, message: :invalid_username_format }
end
