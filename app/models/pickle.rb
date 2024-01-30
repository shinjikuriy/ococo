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

  before_create :set_default_values, :delete_blank_associations

  validates :name, presence: true, length: { maximum: 100 }
  validates :process, presence: true
  with_options length: { maximum: 400 } do
    validates :preparation
    validates :process
    validates :note
  end
  validates :ingredients, presence: true
  validates_associated :ingredients
  validate :include_a_valid_ingredient

  private

  def set_default_values
    self.started_on ||= Date.today
  end

  def include_a_valid_ingredient
    ingredients.each do |ingredient|
      return if ingredient.name.present? && ingredient.quantity.present?
    end
    errors.add(:base, :has_no_ingredient)
  end

  def delete_blank_associations
    ingredients.each do |ingredient|
      if ingredient.name.blank? && ingredient.quantity.blank?
        ingredients.destroy(ingredient)
      end
    end

    sauce_materials.each do |sauce_material|
      if sauce_material.name.blank? && sauce_material.quantity.blank?
        sauce_materials.destroy(sauce_material)
      end
    end
  end
end
