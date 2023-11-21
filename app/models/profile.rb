class Profile < ApplicationRecord
  belongs_to :user

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
end
