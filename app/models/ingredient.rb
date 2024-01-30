# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  pickle_id  :bigint           not null
#  name       :string
#  quantity   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Ingredient < ApplicationRecord
  belongs_to :pickle

  with_options length: { maximum: 100 } do
    validates :name
    validates :quantity
  end

  validate :valid_name_and_quantity

  def incomplete?
    (name.blank? && quantity.present?) || (name.present? && quantity.blank?)
  end

  private

  def valid_name_and_quantity
    if incomplete?
      errors.add(:base, :invalid_name_and_quantity)
    end
  end
end
