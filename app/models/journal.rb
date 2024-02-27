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

  validate :presence_of_pickle
  validates :body, presence: true, length: { maximum: 140 }

  private

  def presence_of_pickle
    errors.add(:pickle_id, I18n.t('errors.messages.inclusion')) unless Pickle.exists?(id: pickle_id)
  end
end
