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
  has_many :ingredients, dependent: :destroy
  has_many :sauce_materials, dependent: :destroy
  accepts_nested_attributes_for :ingredients, :sauce_materials

  before_create :set_default_values

  validates :name, presence: true, length: { maximum: 100 }
  validates :process, presence: true
  with_options length: { maximum: 400 } do
    validates :preparation
    validates :process
    validates :note
  end

  private

  def set_default_values
    self.started_on ||= Date.today
  end
end
