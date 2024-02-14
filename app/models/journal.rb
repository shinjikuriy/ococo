# == Schema Information
#
# Table name: journals
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Journal < ApplicationRecord
  belongs_to :pickle
  has_one :user, through: :pickle

  validates :body, presence: true, length: { maximum: 140 }
end
