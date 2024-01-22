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
class Pickle < ApplicationRecord
  belongs_to :user

  before_create :set_default_values

  validates :name, presence: true, length: { maximum: 100 }

  private

  def set_default_values
    self.started_on ||= Date.today
  end
end
