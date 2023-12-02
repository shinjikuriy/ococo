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
#
class Profile < ApplicationRecord
  belongs_to :user

  before_destroy :purge_attached_file

  enum :prefecture, %i[unselected
                       hokkaido
                       aomori iwate miyagi akita yamagata fukushima
                       ibaraki tochigi gunma saitama chiba tokyo kanagawa
                       niigata toyama ishikawa fukui yamanashi nagano gifu shizuoka aichi
                       mie shiga kyoto osaka hyogo nara wakayama
                       tottori shimane okayama hiroshima yamaguchi
                       tokushima kagawa ehime kouchi
                       fukuoka saga nagasaki kumamoto oita miyazaki kagoshima okinawa
                       outside_japan], prefix: true

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [100, 100]
  end

  private

  def purge_attached_file
    avatar.purge if avatar.attached?
  end
end
